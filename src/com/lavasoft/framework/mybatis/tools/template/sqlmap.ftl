<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd"> 
<#assign package=entityPackage/>
<#assign className=javaTableName?cap_first/>
<#assign tableName=name/>
<#assign columnSize=columnList?size/>
<!-- ${tableName}: ${comment!''}-->
<mapper namespace="${package}.${className}">
    <resultMap id="result_base" type="${package}.${className}">
    <#list columnList as column>
         <#if column.pk>
         	<id property="${column.javaColumnName}" column="${column.name}" jdbcType="${column.jdbcType}"/>
         </#if>
         <#if column.pk==false && column.jdbcType != 'CLOB' && column.jdbcType != 'BLOB'>
         	<result property="${column.javaColumnName}" column="${column.name}" jdbcType="${column.jdbcType}" />
         </#if>
    </#list>
    </resultMap>

    <resultMap id="ResultMapWithBLOBs" type="${package}.${className}WithBLOBs" extends="result_base">
      <#list columnList as column>
       <#if  column.jdbcType =='CLOB' || column.jdbcType == 'CLOB'>
         	<result property="${column.javaColumnName}" column="${column.name}" javaType = "${column.javaType}" jdbcType="${column.jdbcType}" />
       </#if>
    </#list> 
    </resultMap>

	<sql id="columns">
	    <#list columnList as column> ${column.name}<#if (column_index<columnSize-1)>,</#if> </#list>
	</sql>
	
	<sql id="Blob_Column_List">
	    <#list columnList as column><#if  column.jdbcType =='CLOB' || column.jdbcType == 'CLOB'>${column.name},</#if></#list>
	</sql>
	
    <sql id="sql_query_where">
		<where>
        <#list columnList as column>
        <#if  column.jdbcType !='CLOB' && column.jdbcType != 'CLOB'>
            <if test="@Ognl@isNotEmpty(${column.javaColumnName})"> AND ${column.name}  = ${"#{"}${column.javaColumnName}${"}"} </if>
         </#if>
        </#list>
        </where>
    </sql>
    
    <insert id="insert" parameterType="${package}.${className}">
        insert into ${tableName}(
         <include refid="columns"/>
        ) values(
	    <#list columnList as column>${"#{"}${column.javaColumnName},jdbcType=${column.jdbcType} ${"}"}<#if (column_index<columnSize-1)>,</#if></#list>
        )
    </insert>

    <update id="update" parameterType="${package}.${className}">
        update ${tableName} 
        <set>
    <#list columnList as column>
        <#if column.pk>
        <#else>
           <if test="@Ognl@isNotEmpty(${column.javaColumnName})" >
            ${column.name}= ${"#{"}${column.javaColumnName},jdbcType=${column.jdbcType} ${"}"},
           </if>
        </#if>
    </#list>
       </set>
    <#list columnList as column>
        <#if column.pk>
          where ${column.name} =${"#{"}${column.javaColumnName}${"}"}
        </#if>
    </#list>
    </update>

    <delete id="delete" parameterType="java.lang.Long">
        delete from ${tableName} 
    <#list columnList as column>
        <#if column.pk>
          where ${column.name} =${"#{"}${column.javaColumnName}${"}"}
        </#if>
    </#list>
    </delete>

    <select id="load" parameterType="java.lang.Long" resultMap="result_base">
        select * from ${tableName} 
	    <#list columnList as column>
	        <#if column.pk>
	          where ${column.name} =${"#{"}${column.javaColumnName}${"}"}
	        </#if>
	    </#list>
    </select>

    <select id="query" parameterType="map" resultMap="result_base">
        select * from ${tableName}
        <include refid="sql_query_where"/>
		<if test="@Ognl@isNotEmpty(orderField)">
		order by ${r"${orderField}"} ${r"${orderSeq}"}
		</if>
		<if test="@Ognl@isEmpty(orderField)">
		order by <#list columnList as column> <#if column.pk> ${column.name} </#if> </#list>  desc
		</if>
    </select>

    <select id="queryWithBLOBS" parameterType="map" resultMap="ResultMapWithBLOBs">
        select * from ${tableName}
        <include refid="sql_query_where"/>,
        <include refid="Blob_Column_List" />
		<if test="@Ognl@isNotEmpty(orderField)">
		order by ${r"${orderField}"} ${r"${orderSeq}"}
		</if>
		<if test="@Ognl@isEmpty(orderField)">
		order by <#list columnList as column> <#if column.pk> ${column.name} </#if> </#list>  desc
		</if>
    </select>
    
    <select id="count"  parameterType="Map" resultType="Integer">
        select count(1) from ${tableName}
        <include refid="sql_query_where"/>
    </select>
</mapper>
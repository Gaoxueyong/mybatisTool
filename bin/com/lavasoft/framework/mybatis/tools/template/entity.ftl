<#assign package=entityPackage/>
<#assign className=javaTableName?cap_first/>
<#assign tableName=name/>
package ${package};

import com.lavasoft.framework.entity.GenericEntity;

/**
* ${tableName}, ${comment!''}
*
* @author zjl
*/
public class ${className} extends GenericEntity{
<#list columnList as column>
    private ${column.javaType} ${column.javaColumnName};          //${column.comment!''}
</#list>

    public ${className}() {
    }
<#list columnList as column>
    public ${column.javaType} get${column.javaColumnName?cap_first}(){
        return this.${column.javaColumnName};
    }

    public void set${column.javaColumnName?cap_first}(${column.javaType} ${column.javaColumnName}){
        this.${column.javaColumnName}=${column.javaColumnName};
    }
</#list>
}
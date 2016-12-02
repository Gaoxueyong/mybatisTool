<#assign package=daoPackage/>
<#assign className=javaTableName?cap_first/>
<#assign tableName=javaTableName/>
package ${package};

import org.springframework.stereotype.Repository;
import com.lavasoft.framework.core.dao.BaseMybatisDAO;
import ${entityPackage}.${className};

/**
* ${tableName}, ${comment!''}
*
* @author zjl
*/
@Repository
public class ${className}Dao extends BaseMybatisDAO<${className}, Long> {
}
package org.joget.marketplace;

import java.util.Map;
import org.joget.apps.app.service.AppUtil;
import org.joget.apps.form.model.FormData;
import org.joget.apps.form.service.FormUtil;
import org.joget.apps.form.lib.TextField;
import org.joget.commons.util.SecurityUtil;
import org.joget.commons.util.StringUtil;

public class TextFieldMasking extends TextField {

    @Override
    public String getName() {
        return "Text Field Masking";
    }

    @Override
    public String getVersion() {
        return "7.0.1";
    }

    @Override
    public String getDescription() {
        return "Text Field Masking";
    }
    
    @Override
    public String renderTemplate(FormData formData, Map dataModel) {
        // set value
        String value = FormUtil.getElementPropertyValue(this, formData);
        
        value = SecurityUtil.decrypt(value);
        
        if (FormUtil.isReadonly(this, formData) && "true".equalsIgnoreCase(getPropertyString("readonlyLabel"))) {
            String valueLabel = value;
            if (!getPropertyString("style").isEmpty() && "true".equalsIgnoreCase(getPropertyString("storeNumeric"))) {
                valueLabel = StringUtil.numberFormat(value, getPropertyString("style"), getPropertyString("prefix"), getPropertyString("postfix"), "true".equalsIgnoreCase(getPropertyString("useThousandSeparator")), getPropertyString("numOfDecimal"));
            }
            dataModel.put("valueLabel", valueLabel);
        }
        
        dataModel.put("element", this);
        dataModel.put("value", value);

        return FormUtil.generateElementHtml(this, formData, "textFieldMasking.ftl", dataModel);
    }

    @Override
    public String getClassName() {
        return getClass().getName();
    }

    @Override
    public String getFormBuilderTemplate() {
        return "<label class='label'>Text Field Masking</label>";
    }

    @Override
    public String getLabel() {
        return "Text Field Masking";
    }
    
    @Override
    public String getPropertyOptions() {
        String encryption = "";
        if (SecurityUtil.getDataEncryption() != null) {
            encryption = ",{name : 'encryption', label : '@@form.textfield.encryption@@', type : 'checkbox', value : 'false', ";
            encryption += "options : [{value : 'true', label : '' }]}";
        }
        
        return AppUtil.readPluginResource(getClass().getName(), "/properties/form/textFieldMasking.json", new Object[]{encryption}, true, "messages/form/TextFieldMasking");
    }

    @Override
    public String getFormBuilderCategory() {
        return "Marketplace";
    }

    @Override
    public int getFormBuilderPosition() {
        return 500;
    }

    @Override
    public String getFormBuilderIcon() {
        return "<i class=\"fas fa-info\"></i>";
    }

}

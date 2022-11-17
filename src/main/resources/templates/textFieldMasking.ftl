<div class="form-cell" ${elementMetaData!}>
    <#if !(includeMetaData!) && element.properties.style! != "" >
        <script type="text/javascript" src="${request.contextPath}/plugin/org.joget.apps.form.lib.TextField/js/jquery.numberFormatting.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                $('.textfield_${element.properties.elementUniqueKey!}').numberFormatting({
                    format : '${element.properties.style!}',
                    numOfDecimal : '${element.properties.numOfDecimal!}',
                    useThousandSeparator : '${element.properties.useThousandSeparator!}',
                    prefix : '${element.properties.prefix!}',
                    postfix : '${element.properties.postfix!}'
                });
            });
        </script>
    </#if>

    <#if !(includeMetaData!) && element.properties.slots! != "" && element.properties.placeholder! != "" && !(request.getAttribute("org.joget.marketplace.TextFieldMasking")??)>
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                for (const el of document.querySelectorAll("input.masking_element[placeholder][data-slots]")) {
                    const pattern = el.getAttribute("placeholder"),
                        slots = new Set(el.dataset.slots || "_"),
                        prev = (j => Array.from(pattern, (c,i) => slots.has(c)? j=i+1: j))(0),
                        first = [...pattern].findIndex(c => slots.has(c)),
                        accept = new RegExp(el.dataset.accept || "\\d", "g"),
                        clean = input => {
                            input = input.match(accept) || [];
                            return Array.from(pattern, c =>
                                input[0] === c || slots.has(c) ? input.shift() || c : c
                            );
                        },
                        format = () => {
                            const [i, j] = [el.selectionStart, el.selectionEnd].map(i => {
                                i = clean(el.value.slice(0, i)).findIndex(c => slots.has(c));
                                return i<0? prev[prev.length-1]: back? prev[i-1] || first: i;
                            });
                            el.value = clean(el.value).join``;
                            el.setSelectionRange(i, j);
                            back = false;
                        };
                    let back = false;
                    el.addEventListener("keydown", (e) => back = e.key === "Backspace");
                    el.addEventListener("input", format);
                    el.addEventListener("focus", format);
                    el.addEventListener("blur", () => el.value === pattern && (el.value=""));
                }
            });
        </script>
    </#if>

    <label field-tooltip="${elementParamName!}" class="label" for="${elementParamName!}">${element.properties.label} <span class="form-cell-validator">${decoration}</span><#if error??> <span class="form-error-message">${error}</span></#if></label>
    <#if (element.properties.readonly! == 'true' && element.properties.readonlyLabel! == 'true') >
        <div class="form-cell-value"><span>${valueLabel!?html}</span></div>
        <input id="${elementParamName!}_${element.properties.elementUniqueKey!}" name="${elementParamName!}" class="masking_element textfield_${element.properties.elementUniqueKey!}" type="hidden" value="${value!?html}" />
    <#else>
        <input id="${elementParamName!}_${element.properties.elementUniqueKey!}" name="${elementParamName!}" class="masking_element textfield_${element.properties.elementUniqueKey!}" type="text" data-slots="${element.properties.slots!?html}" placeholder="${element.properties.placeholder!?html}" size="${element.properties.size!}" value="${value!?html}" maxlength="${element.properties.maxlength!}" <#if error??>class="form-error-cell"</#if> <#if element.properties.readonly! == 'true'>readonly</#if> />
    </#if>
</div>
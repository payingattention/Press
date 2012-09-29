// ----------------------------------------------------------------------------
// markItUp!
// ----------------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// ----------------------------------------------------------------------------
myMarkdownSettings = {
    nameSpace:          'markdown', // Useful to prevent multi-instances CSS conflict
    resizeHandle:       false,
    previewParserPath:  '~/sets/markdown/preview.php',
    onShiftEnter:       {keepDefault:false, openWith:'\n\n'},
    markupSet: [
        {name:'Title Headline', key:"1", openWith:'### ', placeHolder:'Your title here...', className:"headline" },
        {name:'About Bar (Date, Author, Comments, etc.. Only used once then ignored)', openWith:'* * *\n\n', className:"aboutbar" },
        {name:'More Bar (Displays everything above the more on front page, then MORE button.  Only used once then ignored)', openWith:'- - -\n\n', className:"morebar" },
        {separator:'---------------' },
        {name:'Section Heading (Larger than bold)', key:"2", openWith:'#### ', placeHolder:'Your section heading here...', className:"sectionhead" },
        {name:'SubBold Heading (Smaller than bold)', key:"3", openWith:'##### ', placeHolder:'Your subbold heading here...', className:"subbold" },
        {name:'Admin Comment', key:"4", openWith:'###### ', placeHolder:'Your admin comment here...', className:"admincomment" },
        {separator:'---------------' },        
        {name:'Bold', key:"B", openWith:'**', closeWith:'**', className:"bold" },
        {name:'Italic', key:"I", openWith:'_', closeWith:'_', className:"italic" },
        {name:'Strikethrough', key:"S", openWith:'~~', closeWith:'~~', className:"strikethrough" },
        {separator:'---------------' },
        {name:'Bulleted List', openWith:'- ', className:"bulletedlist" },
        {name:'Numeric List', openWith:function(markItUp) {
            return markItUp.line+'. ';
        }, className:"numericlist" },
        {separator:'---------------' },
        {name:'External Image', key:"P", replaceWith:'![[![Alternative text]!]]([![Url:!:http://]!] "[![Title]!]")', className:"externalimage" },
        {name:'Link', key:"L", openWith:'[', closeWith:']([![Url:!:http://]!] "[![Title]!]")', placeHolder:'Your text to link here...', className:"link" },
        {separator:'---------------'},    
        {name:'Quotes', openWith:'> ', className:"quotes" },
        {name:'Code Block / Code', openWith:'(!(\t|!|`)!)', closeWith:'(!(`)!)', className:"codeblock" },
        {separator:'---------------'},
        {name:'Preview', call:'preview', className:"preview"}
    ]
}

// mIu nameSpace to avoid conflict.
miu = {
    markdownTitle: function(markItUp, char) {
        heading = '';
        n = $.trim(markItUp.selection||markItUp.placeHolder).length;
        for(i = 0; i < n; i++) {
            heading += char;
        }
        return '\n'+heading+'\n';
    }
}
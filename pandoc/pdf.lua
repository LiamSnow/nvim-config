-- Liam's Markdown to PDF (Latex) Lua Script

isCurrentSectionUnnumbered = false

function Header(el)
    hasAsterick = el.content[1].text:sub(1, 1) == "*"

    if el.level == 2 then
        -- H2
        if hasAsterick then
            -- Unnumbered Headings
            el.content[1].text = el.content[1].text:sub(2)
            isCurrentSectionUnnumbered = true
            return pandoc.RawBlock('latex',
                '\\newpage\n\\section*{' .. pandoc.utils.stringify(el.content) .. '}\n\\addcontentsline{toc}{section}{' ..
                    pandoc.utils.stringify(el.content) .. '}')
        else
            -- Numbered Heading
            isCurrentSectionUnnumbered = false
            return pandoc.RawBlock('latex', '\\newpage\n\\section{' .. pandoc.utils.stringify(el.content) .. '}')
        end
    elseif el.level == 3 then
        -- H4
        if hasAsterick or isCurrentSectionUnnumbered then
            -- Unnumbered Subsections
            if hasAsterick then
                el.content[1].text = el.content[1].text:sub(2) -- Remove asterisk
            end
            return pandoc.RawBlock('latex',
                '\\subsection*{' .. pandoc.utils.stringify(el.content) .. '}\n\\addcontentsline{toc}{subsection}{' ..
                    pandoc.utils.stringify(el.content) .. '}')
        else
            -- Numbered Subsections
            return pandoc.RawBlock('latex', '\\subsection{' .. pandoc.utils.stringify(el.content) .. '}')
        end
    else
        -- Other
        return el
    end
end

function Math(el)
    if el.text:find("^%s*\\begin{") ~= nil then
        -- Unnumbered Equation
        return pandoc.RawInline('tex', el.text)
    elseif el.mathtype == 'DisplayMath' and el.text:find("\\begin{equation}") then
        -- Numbered Equation
        local newText = el.text:gsub("^%$+", ""):gsub("%$+$", "")
        return pandoc.RawInline('latex', newText)
    else
        -- Other
        return el
    end
end

function CodeBlock(el)
    if el.classes[1] == 'latex' then
        -- Latex Code Block
        return pandoc.RawBlock('latex', el.text)
    else
        -- Other
        return el
    end
end

return {{
    Header = Header,
    Math = Math,
    CodeBlock = CodeBlock
}}

EPAISSEURS = {
    regular: 500,
    regularitalic: 500,
    italic: 500,
    medium: 600,
    mediumitalic: 600,
    bold: 700,
    bolditalic: 700,
    black: 900,
    blackitalic: 900
}

BASE = %Q[
@font-face {
\tfont-family: "%{nom}";
\tsrc: url('%{url_prefixe}%{url}');
\tfont-weight: %{epaisseur};%{style_special}
}
]

if ARGV.length < 1
    puts "#{$0} out_folder [urls prefix]"
    exit(1)
end

out_folder, url_prefix, = ARGV
url_prefixe = "" if url_prefix.nil?

Dir['fonts/*'].each do |folder|
    font_face_content = ""
    nom = File.basename(folder)
    Dir["#{folder}/*.{woff,otf,ttf}"].each do |font|
        #extension = font.rpartition('.').last
        nom_epaisseur = File.basename(font).rpartition('.').first
        style_special = ""
        if (nom_epaisseur.include?("oblique") or nom_epaisseur.include?("italic"))
            style_special = "\n\tfont-style: italic;"
        end
        proprietes_fonte = {
            nom: nom,
            url_prefixe: url_prefixe,
            url: font,
            epaisseur: EPAISSEURS[nom_epaisseur.to_sym],
            style_special: style_special
        }
        font_face_definition = BASE % proprietes_fonte
        puts font_face_definition
        font_face_content << font_face_definition
    end
    File.write("#{out_folder}/#{nom}.css", font_face_content)
end

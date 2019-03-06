Reference
=========

**Alla kommandon prefixas med “git”**

==================
Allmänna kommandon
==================

 - **Starta rep:** init
 - **Klona rep:** clone [url]
 - **Fixa remote branch:** config --global push.default current
 - **Se alla commits i lista:** log
 - **Visa ändringslogg (hitta commit-id ifall du tappar bort något):** reflog

======================
Skicka och hämta filer
======================

 - **Skicka ändringar till remote:** push
 - **Skicka första gången:** push -u
 - **Tvinga skickandet:** push -fu
 - **Hämta ner ändringar från servern:** pull
 - **Hämta ner ändringar men slå inte ihop med lokala filer:** fetch

============
Filhantering
============

 - **”Spara” filer i git:** add
 - **”Spara” alla ändrade filer:** add -A
 - **Visa filer som ändrats:** status
 - **Ta bort fil ur git:** git rm [filnamn]
 - **För in fil från annan branch:** checkout [branchnamn] – [filnamn]
 - **Klumpa ihop alla filer du lagt till med ”add” för att skicka till remote:** commit (-m [meddelande])
 - **Lägg till filer i den förra klumpen:** commit –amend
 - **Titta på tidigare commits och sammanfoga commits etc.:** rebase -i HEAD~5
 - Byt från pick till andra meddelanden för att byta namn eller sammanfoga commits.
 **pick:** Låt committen vara kvar
 **fixup:** Slår ihop med närmaste pick uppåt

========
Branches
========

 - **Gör en ny branch (en ny version av hemsidan som du kan arbeta i):** branch [branch-name]
 - **Visa alla lokala branches:** branch
 - **Ta bort en branch lokalt och remote:** branch -D
 - **Ta bort en branch lokalt:** branch -d
 - **Byt branch:** checkout
 - **Ny branch och byt:** checkout -b [namn]
 - **Sammanfoga branches på dåligt sätt:** merge [annan branch]
 - **Sammanfoga branches på bra sätt:** rebase [annan branch]
 - **Återställ branch till annan branch:** reset --hard [commit eller branch]
 - **Återställ men ändringar läggs till med add i stage:** reset --soft [commit eller branch]
 - **Återställ men ändringar kan läggas till med add om man vill:** reset --mixed [commit eller branch]

========
Workflow
========
Du vill skriva lite kod och skicka upp till servern

 #. **Gör ny branch:** git checkout -b ny-branch
 #. **Skriv din kod**
 #. **Lägg till ändringar i stage:** git add -A
 #. **Klumpa ihop ändringar och beskriv dem:** git commit
 #. **Skriv ett meddelande som beskriver ändringarna**
 #. **Gå till master-branchen för att se om någon annan ändrat något:** git checkout master
 #. **Hämta ner eventuella ändringar:** git pull
 #. **Gå till din egna branch för att sammanfoga ändringarna:** git checkout ny-branch
 #. **Hämta in ändringar från master:** git rebase master
 #. **Lös konflikter genom att gå igenom manuellt eller kör kommandot:** git checkout XXX – [filnamn]
 i. XXX = ours för att ta filen från den andra branchen
 ii. XXX = theirs för att ha kvar filen
 #. **Fortsätt med sammanfogningen (om det inte går fortsätt med steg 10):** git rebase --continue
 #. **Skicka filer till branchen på remote:** git push (-fu om det inte fungerar)
 #. **Gå in på github och skapa en pull request där du beskriver vad du gjort och gör eventuella ändringar som bottar och personer föreslår.**

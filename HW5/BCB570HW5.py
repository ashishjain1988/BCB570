#! /usr/bin/python
import Bio.UniProt.GOA as go

'''
@author: Ashish Jain
@organization: Iowa State University
'''

def giveGOAResults(filePath,orgName):
    codeList = ("EXP", "IDA", "IPI", "IMP", "IGI", "IEP")
    annotatedProteinList = []
    #unannoatatedProteinList = []
    totalProteinList = []
    with open(filePath) as handle:
        i = 1 
        for record in go.gafiterator(handle):
            i = i + 1
            proteinId = record["DB_Object_ID"]
            evidenceCode = record["Evidence"]
            totalProteinList.append(proteinId)
            if evidenceCode in codeList:
                annotatedProteinList.append(proteinId)
#                if proteinId not in annotatedProteinList:
#                    annotatedProteinList.append(proteinId)
#               if proteinId in unannoatatedProteinList:
#                    unannoatatedProteinList.remove(proteinId)
#            else:
#                if proteinId not in annotatedProteinList + unannoatatedProteinList:
#                    unannoatatedProteinList.append(proteinId)
    totalProteins = len(set(totalProteinList))
    annotatedProtein = len(set(annotatedProteinList))
    unannoatatedProtein = totalProteins - annotatedProtein
    percent = (annotatedProtein * 100.0)/totalProteins
    print orgName,"Exp. Annotated:",annotatedProtein,"Exp. Unannotated:",unannoatatedProtein,"Total:",totalProteins,"Percent Exp Annotated:",percent
    handle.close();
            
def main():
    giveGOAResults("goa_human.gaf","Human")
    giveGOAResults("goa_mouse.gaf","Mouse")
    giveGOAResults("goa_rat.gaf","Rat")
    giveGOAResults("goa_chicken.gaf","Chicken")
    giveGOAResults("goa_zebrafish.gaf","Zebrafish")

if __name__ == '__main__':
    main()
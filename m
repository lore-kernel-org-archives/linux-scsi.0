From: Matthew Wilcox <matthew@wil.cx>
Subject: Brown Paper Bag for 2.1.18m
Date: Fri, 22 Oct 2004 13:49:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022124944.GD4201@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:29840 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271299AbUJVMto
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 08:49:44 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CKyrY-0004Tc-6l
	for linux-scsi@vger.kernel.org; Fri, 22 Oct 2004 13:49:44 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Joel Soete noticed this brown paper bag bug in the 2.1.18m release.
Please apply this patch on top of 2.1.18m.

Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.69
diff -u -p -r1.69 sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	21 Oct 2004 21:07:56 -0000	1.69
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	22 Oct 2004 12:47:37 -0000
@@ -2308,7 +2308,7 @@ static void sym2_set_qas(struct scsi_tar
 	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[starget->id];
 
-	if (starget)
+	if (qas)
 		tp->tinfo.goal.options |= PPR_OPT_QAS | PPR_OPT_DT;
 	else
 		tp->tinfo.goal.options &= ~PPR_OPT_QAS;

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

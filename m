From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [PATCH 2.5] megaraid driver updates 2/4
Date: Wed, 30 Oct 2002 16:14:44 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301614190.29157-100000@humbolt.us.dell.com>
References: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.808.11.2, 2002-10-28 10:14:07-06:00, Matt_Domsch@dell.com
  megaraid: s/pcibios_read_config/pci_read_config


 megaraid.c |    6 ++----
 1 files changed, 2 insertions, 4 deletions


diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	Wed Oct 30 15:55:41 2002
+++ b/drivers/scsi/megaraid.c	Wed Oct 30 15:55:41 2002
@@ -2867,16 +2867,14 @@
 		pciDevFun = pdev->devfn;
 #endif
 		if ((flag & BOARD_QUARTZ) && (skip_id == -1)) {
-			pcibios_read_config_word (pciBus, pciDevFun,
-						  PCI_CONF_AMISIG, &magic);
+			pci_read_config_word (pdev, PCI_CONF_AMISIG, &magic);
 			if ((magic != AMI_SIGNATURE)
 			    && (magic != AMI_SIGNATURE_471)) {
 				pciIdx++;
 				continue;	/* not an AMI board */
 			}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-			pcibios_read_config_dword (pciBus, pciDevFun,
-						   PCI_CONF_AMISIG64, &magic64);
+			pci_read_config_dword (pdev, PCI_CONF_AMISIG64, &magic64);
 
 			if (magic64 == AMI_64BIT_SIGNATURE)
 				flag |= BOARD_64BIT;

===================================================================


This BitKeeper patch contains the following changesets:
1.808.11.2
## Wrapped with gzip_uu ##


begin 664 bkpatch28982
M'XL(`%U5P#T``[64;6O;,!2%/UN_0E`8&ZOM*UF6'8^,=LG6AJUK2.EGHTA*
M;!I'P7+3#?SCJV1+%KHTV:MM,+Y<'<ZY]\$G^-;J.O.N1-/D?5-96:`3?&EL
MDWE*SV:!-)4KC(QQA;`PE0XKM6X+QW?AK)S??_%I$/N5GHI:E`JYYJ%H9(&7
MNK:91X)H6VF^+G3FC=Y?W'XZ'R'4[>)>(>93?:,;W.VBQM1+,5/V3#3%S,R#
MIA9S6^E&K#RTV]:6`E!WQR2)(.8MX<"25A)%B&!$*Z`LY0SM!#K;!'DB0H!2
MPB,`UE+&8XKZF`0II`$A`<5`0P(A33&!C+`,$A]X!H#W">/7!/N`WN%_FZ&'
M)-X,-L,V7,AR7!J;UUJH7)KYI)RN:KO?Z"->94G0\,=PD?^;%T(@`+T]DD;5
MY6K'H96V##<V`[F3C0%T6B!1PMH4.A,QEA&5DTZ4`-\[QH.2;ELIX80!;6/>
MB>(U0,\<.([37YG?#]<1\PXUZFRW'")G?H4:93]!1@]"1K'/_@MDOXK6M\%?
M8[]^6#\.E>%S._@#ZOHT30!3-'!O@@GR/.^)A_S!U`J_7"B]/,7#WB#O77_^
MD)]?#6X&%Z?X126FI7SU9BV4?A?J[!=2!Y0XVVAQYM2V/S!9:'EG[ZNN4)%*
,((W1(QW84@T_!0``
`
end


From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [PATCH 2.5] megaraid driver updates 4/4
Date: Wed, 30 Oct 2002 16:15:46 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301615250.29157-100000@humbolt.us.dell.com>
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


ChangeSet@1.871, 2002-10-30 13:11:37-06:00, Matt_Domsch@dell.com
  megaraid: cleanups so it builds again


 megaraid.c |    1 -
 megaraid.h |    2 --
 2 files changed, 3 deletions


diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	Wed Oct 30 15:56:49 2002
+++ b/drivers/scsi/megaraid.c	Wed Oct 30 15:56:49 2002
@@ -4123,7 +4123,6 @@
 	struct partition *p, *largest = NULL;
 	int i, largest_cyl;
 	int heads, cyls, sectors;
-	int capacity = capacity;
 	unsigned char *buf;
 
 	if (!(buf = scsi_bios_ptable(bdev)))
diff -Nru a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h	Wed Oct 30 15:56:49 2002
+++ b/drivers/scsi/megaraid.h	Wed Oct 30 15:56:49 2002
@@ -214,8 +214,6 @@
     info:	     	megaraid_info,	   	/* Driver Info Function		*/\
     command:	  	megaraid_command,	/* Command Function		*/\
     queuecommand:  	megaraid_queue,		/* Queue Command Function	*/\
-    abort:	    	megaraid_abort,	  	/* Abort Command Function	*/\
-    reset:	    	megaraid_reset,	  	/* Reset Command Function	*/\
     bios_param:     	megaraid_biosparam, 	/* Disk BIOS Parameters		*/\
     can_queue:		MAX_COMMANDS,	    	/* Can Queue			*/\
     this_id:	  	7,		       	/* HBA Target ID		*/\

===================================================================


This BitKeeper patch contains the following changesets:
1.871
## Wrapped with gzip_uu ##


begin 664 bkpatch29096
M'XL(`*%5P#T``[6576O;,!2&KZ-?<:"7FVT=2?Z$C&[-V&`;*QF]'K*LQ*;^
M"):<KN`?/R4E;>E'VF2K[:O#X?@][_,*G<"%T7TV^2&M_3WK&J-*<@)?.V.S
M2:'KVE==XPKSKG.%H.P:'33%MBW(+X.Z:H<_'O-#K]%+V<NJ(*[Y7%I5PEKW
M)IN@SV\K]GJEL\G\\Y>+[Q_GA$RG<%;*=JE_:0O3*;%=OY9U84ZE+>NN]6TO
M6]-H*S<:QMO6D5'*W!MBS&D8C1A1$8\*"T0I4!>4B202Y-Y"I[M%'@Q!RBG&
M(L9D#%$D2&:`?A(C4!8@#3@%Y!EBQF./1AFE\-1,>,?`H^03_%_Y9T3!SM,,
M5*UE.ZP,F`XJ"_E0N1^!7,JJ)=_`B1><G-^Y2;P#'T*HI.3#"SL4?;6!&AAE
MJF`GSE?W-A*4IB-%'HLQH>E"YHHSM4AY3*,GS=L[<HLG1>1L##?SC]17/M+'
M'.Q1*$P3)L)$"LX7C!VBKWRH+^)QG&X3_<Q"+^?[G\Q].NW[S64I#7D:BC$4
M+$ZVV6?1H^BSO=&GX.&;1'^NFVZMH>VNH!A6=:6DU:#D2JK*7L-:]I7,:[W)
M_C89/\'KK[:?R_+Y<Q"..!8S@<X4W(.V/!;M*W-Y"-KR(5J:4'Z#%MGA:-E;
MHI5YUUN0;0&]-NX"<).*VJWT'@:CH=`+.=066GT%NH2J-5;+PG?`;X[:JX"7
>QP!G&`.[N\54J=6E&9HIC_.<RI23OQA#UEHR!P``
`
end


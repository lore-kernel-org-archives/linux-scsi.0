From: Matthew Tehonica <matt.tehonica@mac.com>
Subject: Re: Applying MVSAS Patch
Date: Fri, 18 Dec 2009 08:54:06 -0500
Message-ID: <105495033028979535461096937726809251647-Webmail@me.com>
References: <67980649284293627495293095942659870934-Webmail@me.com>
 <20091216081301.59d1698e.randy.dunlap@oracle.com>
 <93017718277361587250366956065608636194-Webmail@me.com>
 <20091216090430.66b7f389.randy.dunlap@oracle.com>
 <29479280-86A1-4DF5-BA64-F2F0F1A4838B@mac.com>
 <20091216101617.a6499cad.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asmtpout026.mac.com ([17.148.16.101]:57793 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZLRNyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 08:54:39 -0500
Received: from spool003.mac.com ([10.150.69.53])
 by asmtp026.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTP id <0KUU0062EPA7TT40@asmtp026.mac.com> for
 linux-scsi@vger.kernel.org; Fri, 18 Dec 2009 05:54:08 -0800 (PST)
In-reply-to: <20091216101617.a6499cad.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ayan@marvell.com" <ayan@marvell.com>

=20
On Wednesday, December 16, 2009, at 01:16PM, "Randy Dunlap" <randy.dunl=
ap@oracle.com> wrote:
>On Wed, 16 Dec 2009 13:08:08 -0500 Matt Tehonica wrote:
>
>>=20
>> Andy Yan very kindly emailed me the patches but the first seemed to =
be =20
>> only garbage so I grabbed it from Marc.info. Must have not copied =20
>> correctly. Could anyone send me the first patch file again??
>
>I just did that.
>
>On marc.info (http://marc.info/?l=3Dlinux-scsi&m=3D125773523811252&w=3D=
2),
>did you click on [Download message RAW] to get the unformatted message=
?
>
>---
>~Randy
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

So I've gotten all 7 patches applied and I'm trying to run the make com=
mand to build the kernel and getting the following error:

<snip>
  LD [M]  drivers/scsi/mpt2sas/mpt2sas.o
  LD      drivers/scsi/mvsas/built-in.o
  CC [M]  drivers/scsi/mvsas/mv_init.o
  CC [M]  drivers/scsi/mvsas/mv_sas.o
drivers/scsi/mvsas/mv_sas.c: In function =91mvs_slave_configure=92:
drivers/scsi/mvsas/mv_sas.c:417: error: =91SCSI_QDEPTH_DEFAULT=92 undec=
lared (first use in this function)
drivers/scsi/mvsas/mv_sas.c:417: error: (Each undeclared identifier is =
reported only once
drivers/scsi/mvsas/mv_sas.c:417: error: for each function it appears in=
=2E)
drivers/scsi/mvsas/mv_sas.c:417: error: too many arguments to function =
=91sas_change_queue_depth=92
make[3]: *** [drivers/scsi/mvsas/mv_sas.o] Error 1
make[2]: *** [drivers/scsi/mvsas] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

Anyone have any ideas on this??  It compiled fine until I applied those=
 7 patches.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

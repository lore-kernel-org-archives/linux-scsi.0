From: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Subject: RE: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 22 Feb 2006 13:24:34 -0800
Message-ID: <8C064C48AB104B428CBA524C342357CA324AE4@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34513 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751389AbWBVVYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2006 16:24:35 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Tarte@us.ibm.com, Jeff Garzik <jgarzik@redhat.com>

What model ia64 are you running James?  I'll see if Adaptec has one to
try to help reproduce this issue.  Jeff, have you tried the fixes to see
if they addressed the issues you were seeing (OCM error when BIOS off
and booted off of SCSI)?

Rob

-----Original Message-----
From: Mike Anderson [mailto:andmike@us.ibm.com] 
Sent: Tuesday, February 21, 2006 10:26 PM
To: James Bottomley
Cc: linux-scsi@vger.kernel.org; Tarte@us.ibm.com; Tarte, Robert; Jeff
Garzik
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> Actually, it's still not quite working for me.  This is what I get
from
> 2.6.16-rc4 with the Jeff Garzik SAS tree (which has this fix applied).
> The soft lockup basically means it was hung in asd_read_ocm():

ok, looking into this. Is the soft lockup detect in the same
(asd_read_ocm+0x120) function and offset. I did a resync with Jeff's
tree
and ran the code on a ppc64 system. This ran ok. I will move my card to
an
IA64 tomorrow to see if I can recreate (which may be unlikely as it ran
a
number of loads before) and also generate a .lst file.

-andmike
--
Michael Anderson
andmike@us.ibm.com



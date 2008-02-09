From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH 1/3] mpt fusion: Request I/O resources only whenrequired
Date: Sun, 10 Feb 2008 01:26:21 +0800
Message-ID: <5AE055B67BB5764693E2900C7E3699BEFB1C5C@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48152 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbYBIR03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 12:26:29 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

Thanks James for pointing the missing of checkpatch.pl check. I will do
it before submitting the future patches.
 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, February 08, 2008 10:54 PM
To: Prakash, Sathya
Cc: linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: [PATCH 1/3] mpt fusion: Request I/O resources only
whenrequired


On Fri, 2008-02-08 at 22:05 +0530, Prakash, Sathya wrote:
> This patch modifies the I/O resource allocation behavior of FUSION
driver. 
> The current version of driver allocates the I/O resources even if they
are not required and this creates trouble in low resource environments.
> This driver now uses pci_enable_device_mem/pci_enable_device functions
to differentiate the resource allocations.
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
  ^
Capital 'S'

The patch could also have done with a bit of checkpatch.pl love:

WARNING: Signed-off-by: is the preferred form
#58: 
signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>

ERROR: need space after that ',' (ctx:VxV)
#83: FILE: drivers/message/fusion/mptbase.c:1486:
+                   "failed\n",ioc->name);
                              ^

ERROR: use tabs not spaces
#84: FILE: drivers/message/fusion/mptbase.c:1487:
+ ^I^Ireturn r;$

ERROR: need space after that ',' (ctx:VxV)
#89: FILE: drivers/message/fusion/mptbase.c:1492:
+                   "MEM failed\n",ioc->name);
                                  ^

ERROR: trailing whitespace
#123: FILE: drivers/message/fusion/mptbase.c:1833:
+^I^I^Ireturn 0; $

WARNING: line over 80 characters
#179: FILE: drivers/message/fusion/mptbase.h:632:
+       int                     bars;   /* bitmask of BAR's that must be
configured */

total: 4 errors, 2 warnings, 105 lines checked

YJames


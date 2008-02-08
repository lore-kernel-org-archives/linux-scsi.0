From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] mpt fusion: Request I/O resources only when
	required
Date: Fri, 08 Feb 2008 11:24:15 -0600
Message-ID: <1202491455.3102.47.camel@localhost.localdomain>
References: <20080208163534.GA20640@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54444 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764295AbYBHRYW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 12:24:22 -0500
In-Reply-To: <20080208163534.GA20640@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com


On Fri, 2008-02-08 at 22:05 +0530, Prakash, Sathya wrote:
> This patch modifies the I/O resource allocation behavior of FUSION driver. 
> The current version of driver allocates the I/O resources even if they are not required and this creates trouble in low resource environments.
> This driver now uses pci_enable_device_mem/pci_enable_device functions to differentiate the resource allocations.
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


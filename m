From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/5] BNX2I - Add 5771E device support to bnx2i driver
Date: Thu, 10 Dec 2009 09:43:12 -0600
Message-ID: <1260459792.2457.75.camel@mulgrave.site>
References: <1260214773.31468.92.camel@anilgv-desktop>
	 <4B2060AE.7090005@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47417 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503AbZLJPnU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 10:43:20 -0500
In-Reply-To: <4B2060AE.7090005@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, mchan@broadcom.com, poswald@novell.com

On Wed, 2009-12-09 at 20:45 -0600, Mike Christie wrote:
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

But not by checkpatch:

ERROR: trailing whitespace
#23: FILE: drivers/scsi/bnx2i/bnx2i_init.c:90:
+^I^Iprintk(KERN_ALERT "bnx2i: unknown device, 0x%x\n", $

total: 1 errors, 0 warnings, 13 lines checked

I've fixed it up.  And the several other whitespace problems in the rest
of the patch set.

James



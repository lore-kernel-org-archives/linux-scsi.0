From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: Re: [PATCH 1/5] BNX2I - Add 5771E device support to bnx2i
 driver
Date: Thu, 10 Dec 2009 10:24:28 -0800
Message-ID: <1260469468.31468.130.camel@anilgv-desktop>
References: <1260214773.31468.92.camel@anilgv-desktop>
 <4B2060AE.7090005@cs.wisc.edu> <1260459792.2457.75.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4566 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761246AbZLJSYT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 13:24:19 -0500
In-Reply-To: <1260459792.2457.75.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Michael Chan <mchan@broadcom.com>, "poswald@novell.com" <poswald@novell.com>

On Thu, 2009-12-10 at 07:43 -0800, James Bottomley wrote:
> On Wed, 2009-12-09 at 20:45 -0600, Mike Christie wrote:
> > Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> But not by checkpatch:
> 
> ERROR: trailing whitespace
> #23: FILE: drivers/scsi/bnx2i/bnx2i_init.c:90:
> +^I^Iprintk(KERN_ALERT "bnx2i: unknown device, 0x%x\n", $
> 
> total: 1 errors, 0 warnings, 13 lines checked
> 
> I've fixed it up.  And the several other whitespace problems in the rest
> of the patch set.
> 

Thanks James. In future will make sure not to repeat the slip-up.

Thanks again.

> James
> 
> 
> 



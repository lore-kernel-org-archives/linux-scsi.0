From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 13:11:44 +0000
Message-ID: <20111111131144.GB10242@srcf.ucam.org>
References: <4EBCEDED.7030907@parallels.com>
 <1321014474.5161.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:47158 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1KKNLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 08:11:49 -0500
Content-Disposition: inline
In-Reply-To: <1321014474.5161.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Vasiliy Averin <vvs@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>, Shaohua Li <shaohua.li@intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>

On Fri, Nov 11, 2011 at 12:27:55PM +0000, James Bottomley wrote:

> The next question is: is the driver the correct place?  This sounds like
> a PCIe Link Power Management blacklist set ... which might need updating
> on the fly ... might we need a user knob for this (like we have for the
> SCSI black/white list)?

The only thing that knows whether any given piece of hardware is broken 
here is the hardware-specific driver. There's already a user knob for 
this, but some devices will fall over the moment the hardware is enabled 
if the ASPM state is broken which makes it more difficult to fix up that 
way.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

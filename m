From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 13:53:00 +0000
Message-ID: <20111111135300.GA10798@srcf.ucam.org>
References: <4EBCEDED.7030907@parallels.com>
 <1321014474.5161.10.camel@dabdike.int.hansenpartnership.com>
 <20111111131144.GB10242@srcf.ucam.org>
 <4EBD278B.6050707@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:56865 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab1KKNxD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 08:53:03 -0500
Content-Disposition: inline
In-Reply-To: <4EBD278B.6050707@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>, Shaohua Li <shaohua.li@intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>

On Fri, Nov 11, 2011 at 05:47:55PM +0400, Vasily Averin wrote:

> It's quite hard to identify all affected hardware, as far as I understand in all cases it was various controllers.
> Probably hardware vendor could do it, but I doubt that it is possible in current situation.

Yeah, without assistance from the vendor it becomes much harder to do. 
It's worth noting that there are (as far as I know) no situations in 
which we'll enable ASPM when Windows won't if the "Maximum power 
savings" option is enabled, so hardware that's broken on Linux should 
also be broken on Windows. In theory ASPM should be blacklisted in the 
Windows driver .inf, but it turns out that some vendors do it directly 
in the drivers instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

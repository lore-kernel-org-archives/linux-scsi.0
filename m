From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_transport_spi.c
Date: Mon, 10 Jan 2005 21:17:57 +0000
Message-ID: <20050110211757.GQ27371@parcelfarce.linux.theplanet.co.uk>
References: <91888D455306F94EBD4D168954A9457C2023B3@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:57486 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262610AbVAJVSE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 16:18:04 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C2023B3@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephens, Larry" <larry.stephens@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Mon, Jan 10, 2005 at 02:07:14PM -0700, Stephens, Larry wrote:
> I'm in the initial stages of looking at modifying the LSI driver to utilize
> the Domain Validation code in scsi_transport_spi.c rather than our own
> driver DV code.

Yay!

> I've installed RHEL 4.  Where can I obtain the kernel source file for kernel
> 2.6.9-1.906_ELsmp, containing scsi_transport_spi.c?

Well, RHEL 4 is currently not released, so I can't tell you ;-)

You'd probably be best off starting with the 2.6.10 kernel from
http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.10.tar.bz2

That way, your development work won't be impeded by trying to rebuild
RPMs, and contributing the changes back will be easier since you won't
inadvertently depend on a change Red Hat have made to their kernel..

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

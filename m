From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Sat, 10 Dec 2005 02:34:26 +0000
Message-ID: <20051210023426.GA31220@srcf.ucam.org>
References: <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org> <20051209114944.GA1068@havoc.gtf.org> <20051209115235.GB25771@srcf.ucam.org> <43997171.9060105@pobox.com> <20051209121124.GA25974@srcf.ucam.org> <439975AB.5000902@pobox.com> <20051209122457.GB26070@srcf.ucam.org> <439A23E8.3080407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([217.147.92.49]:46306 "EHLO
	vavatch.codon.org.uk") by vger.kernel.org with ESMTP
	id S932710AbVLJCe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 21:34:57 -0500
Content-Disposition: inline
In-Reply-To: <439A23E8.3080407@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Fri, Dec 09, 2005 at 07:40:08PM -0500, Jeff Garzik wrote:

> ICH6 and ICH7 support it just fine, through the normal SATA PHY 
> registers.  ICH5 only support it if you are clever :)

ICH6 supports it even in non-AHCI mode? You may want to update the 
website, then :)

> Further, although one can detect hot-unplug on ICH5, hotplug is probably 
> not detectable without polling or SMI.

ACPI allows us to detect hotplug on ICH5, which sounds like a good 
argument for its inclusion.
-- 
Matthew Garrett | mjg59@srcf.ucam.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: IO transfer limits
Date: Thu, 11 Jan 2007 18:17:18 -0700
Message-ID: <1168564639.2983.42.camel@mulgrave.il.steeleye.com>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net>
	 <8268682.post@talk.nabble.com>
	 <1168539824.2983.11.camel@mulgrave.il.steeleye.com>
	 <8284792.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39631 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932515AbXALBR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 20:17:28 -0500
In-Reply-To: <8284792.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john clyne <clyne@ucar.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-01-11 at 11:48 -0800, john clyne wrote:
> So what's the best course of action for increasing the 512kb IO transfer size
> limit, changing SCSI_MAX_PHYS_SEGMENTS (currently 128 and apparently can be
> set no greater than 256), or increasing the page size? Or is there another
> option.

Well, without knowing the details of what you want to do it's hard to
say.  Doug offered you a method via SG_IO (albeit involving buffer
copying); you can just increase the SCSI_MAX_PHYS_SEGMENTS, or you could
increase the PAGE_SIZE or use an IOMMU.  For a given workload, you'll
just have to see which works out best in practice.

James



From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: Thu, 8 Jan 2004 20:06:43 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108200643.A15176@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B060EDD4@AVEXCH02.qlogic.org> <20040108165414.A12233@infradead.org> <20040108193336.GB10243@beaverton.ibm.com> <20040108193427.A14545@infradead.org> <20040108195732.GB10391@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:44049 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266344AbUAHUGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 15:06:46 -0500
Content-Disposition: inline
In-Reply-To: <20040108195732.GB10391@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Jan 08, 2004 at 11:57:32AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Thu, Jan 08, 2004 at 11:57:32AM -0800, Mike Anderson wrote:
> > With sends are you referring to function that support certain scsi
> > commands like report luns and report capacity?  We have a perfectly
> > fine interface for that and it's SG_IO.. 
> 
> I was thinking about the fabric management functions section of the
> spec.

Hmm, I don't remember those in the copy I have.  It appears there's
a V2 of the spec on the SNIA server now and I'll take a look at
what they are supposed to do.

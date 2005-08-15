From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LLDD: scatterlists only?
Date: Mon, 15 Aug 2005 11:17:01 +0100
Message-ID: <20050815101701.GB590@infradead.org>
References: <20050814232446.58676.qmail@web51604.mail.yahoo.com> <1124063460.18802.27.camel@mulgrave> <43003471.5000108@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10198 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932629AbVHOKRE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 06:17:04 -0400
Content-Disposition: inline
In-Reply-To: <43003471.5000108@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, michaelc@cs.wisc.edu, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 15, 2005 at 04:21:37PM +1000, Douglas Gilbert wrote:
> I haven't looked at what would be involved with the sg
> driver but it is good to hear Mike C. is working on it.
> 
> Hopefully scsi_cmnd::buffer and bufflen get _less_ generic
> names in the process.

I'm not sure it's a that good idea as it would break old drivers
while now they just continue to work with a bit of dead code.


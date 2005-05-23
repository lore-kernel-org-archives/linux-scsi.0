From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Mon, 23 May 2005 16:45:16 -0400
Message-ID: <20050523204516.GA28058@havoc.gtf.org>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([69.61.70.25]:30116 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261960AbVEWUp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 16:45:26 -0400
Content-Disposition: inline
In-Reply-To: <1116880875.5021.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Mon, May 23, 2005 at 03:41:15PM -0500, James Bottomley wrote:
> On Mon, 2005-05-23 at 16:15 -0400, Jeff Garzik wrote:
> > Patch is via Mark Lord, 
> 
> Um, it is? it looks identical to this one from Jens (down to the
> gratuitous style corrections)
> 
> http://marc.theaimsgroup.com/?t=111409327100001

Got it "via" Mark Lord; I didn't know the proper attribution.


> However, before anything happens I'd like to get the SCSI pieces
> correct.

The "anything" I want to happen here is getting the SCSI pieces correct ;-)



> The thread petered out before a resolution, however, I think
> at least disk devices should be doing a synchronize cache on suspend.

Agreed.

	Jeff




From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: use block-layer tags
Date: Wed, 13 Oct 2004 23:00:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041013220014.GA3631@infradead.org>
References: <Pine.LNX.4.60.0410122307180.4565@poirot.grange> <Pine.LNX.4.60.0410132131040.3426@poirot.grange> <1097704168.1714.262.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:30469 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269870AbUJMWAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 18:00:21 -0400
Content-Disposition: inline
In-Reply-To: <1097704168.1714.262.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 13, 2004 at 04:49:22PM -0500, James Bottomley wrote:
> On Wed, 2004-10-13 at 14:35, Guennadi Liakhovetski wrote:
> > On Tue, 12 Oct 2004, Guennadi Liakhovetski wrote:
> > 
> > > Slightly tested. Applies on the top of all up to date tmscsim patches (if 
> > > I didn't miss any). Reviews, tests highly welcome. Inline patch should be 
> > > fine now. Will re-send if still not...
> > 
> > I think, there was (at least) one missing chunk in the first version of 
> > the patch. Here's an updated version. Patch inlining seems to work indeed 
> > now.
> 
> This doesn't want to apply to scsi-misc-2.6 ...
> 
> Patch failed.  **** patch log follows ****
> Patching file drivers/scsi/tmscsim.c
> 11 out of 13 hunks FAILED -- saving rejects to file
> drivers/scsi/tmscsim.c.rej

scsi-misc still seems to be missing the patch to merge scsiiom.c into
tmscsim.c

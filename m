From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: new interfaces
Date: Fri, 28 May 2004 14:00:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528130001.GA27804@infradead.org>
References: <20040526114521.GA24166@infradead.org> <Pine.LNX.4.44.0405272302580.8367-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:8374 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262873AbUE1NAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 09:00:06 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405272302580.8367-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, May 27, 2004 at 11:20:50PM +0200, Guennadi Liakhovetski wrote:
> On Wed, 26 May 2004, Christoph Hellwig wrote:
> 
> > Looks like a way to go.  I'm not sure what scan_device is supposed to
> > do as I already wrote, but from looking at when it's set/cleared I'm
> > pretty sure it tries to indicate whethere we're currently scanning for
> > devices.  And useing slave_alloc/slave_configure is a much safer way to
> > find that out then guessing from the commands sent.
> 
> Attached is a patch, that moves scan_device to
> slave_alloc/_configure/_destroy, as you suggested (to be precise, as I
> understood your suggestion:-)). Please consider. The patch also contains
> some more clean-up. Don't know, if you, James, would prefer it as a
> separate patch, or left alone altogether. Those minor details are
> disturbing the eye, but are, perhaps, not important enough to bother you
> with a separate patch:-) But if you want it separate - no problem, will do
> that.
> 
> As usual, tested on my AM53C974.

Looks good to me.

From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] tmscsim: new interfaces
Date: 29 May 2004 10:36:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085845021.2103.3.camel@mulgrave>
References: <Pine.LNX.4.44.0405272302580.8367-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20404 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264304AbUE2PhR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 11:37:17 -0400
In-Reply-To: <Pine.LNX.4.44.0405272302580.8367-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, 2004-05-27 at 16:20, Guennadi Liakhovetski wrote:
> Attached is a patch, that moves scan_device to
> slave_alloc/_configure/_destroy, as you suggested (to be precise, as I
> understood your suggestion:-)). Please consider. The patch also contains
> some more clean-up. Don't know, if you, James, would prefer it as a
> separate patch, or left alone altogether. Those minor details are
> disturbing the eye, but are, perhaps, not important enough to bother you
> with a separate patch:-) But if you want it separate - no problem, will do
> that.

Well, I'll leave that up to you.  It is nice clearly to separate
different updates in different patches ... but I have drivers that go
into the tree containing a bunch of different changes with a single
comment like "update to version xxx", so I don't insist on this.

James



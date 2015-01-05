From: Christoph Hellwig <hch@lst.de>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
	max_hw_sectors cap")
Date: Mon, 5 Jan 2015 18:19:40 +0100
Message-ID: <20150105171940.GC30028@lst.de>
References: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org> <54A2D07B.4040607@interlog.com> <alpine.DEB.2.10.1412300830420.12831@tosh-p75a>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55173 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbbAERTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 12:19:42 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412300830420.12831@tosh-p75a>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kenneth R. Crudup" <kenny@panix.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, Dec 30, 2014 at 08:36:34AM -0800, Kenneth R. Crudup wrote:
> OP here. FWIW, this is what I get when running that command on the SCSI
> generic device that corresponds to the USB-3 (non-UAS) disk[1] that had the
> issue:

So it looks like this one actually provides sane values, but we don't
we never even look at EVPD pages for usb devices due to the wrong SCSI
level?

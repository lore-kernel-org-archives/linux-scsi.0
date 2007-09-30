From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 13/16] gdth: Make one abuse of scsi_cmnd less obvious
Date: Sun, 30 Sep 2007 17:21:35 -0600
Message-ID: <20070930232135.GF12049@parisc-linux.org>
References: <46FFFC8C.6080804@panasas.com> <47000367.6090402@panasas.com> <20070930212813.GD13343@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33781 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXI3XVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 19:21:39 -0400
Content-Disposition: inline
In-Reply-To: <20070930212813.GD13343@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30, 2007 at 10:28:13PM +0100, Christoph Hellwig wrote:
> I think it would be better if your whole patch series goes ontop of
> willy's ->done removal series instead.  I really hope we can get that
> one into scsi-misc ASAP.

Actually, I think if Boaz simply flips this patch to be after his next
one (or merges them ...), there's no real dependency on the ->done
removal.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

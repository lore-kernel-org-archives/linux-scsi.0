From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 11:20:15 -0600
Message-ID: <20080625172015.GR4392@parisc-linux.org>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53533 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYFYRUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 13:20:32 -0400
Content-Disposition: inline
In-Reply-To: <20080625165759.GC20851@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25, 2008 at 06:57:59PM +0200, Jens Axboe wrote:
> Precisely, merging and fairness is a big part of it. Plus, doing this in
> sd is just a blatant layer violation.

I'm fine with tweaking the elevators to know about low-latency seeks.
But please stop describing it as "a blatant layering violation".
It's nothing of the sort.  It's setting a default at a point where we
find out the information which would guide us.

I haven't looked into doing this in udev yet; I've got caught up in
another project.  In any case, it seems like there's no role for udev
any more, so I'll probably not spend any more time on this unless there's
some need.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] resubmit: cciss: procfs updates to display info about many volumes
Date: Thu, 21 Feb 2008 08:57:44 +0100
Message-ID: <20080221075743.GE23197@kernel.dk>
References: <20080220214400.GA13443@roadking.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:21655 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbYBUH5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 02:57:47 -0500
Content-Disposition: inline
In-Reply-To: <20080220214400.GA13443@roadking.usa.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com, coldwell@redhat.com, adobriyan@gmail.com, randy.dunlap@oracle.com

On Wed, Feb 20 2008, Mike Miller wrote:
> Patch 1 of 1
> 
> This patch hopefully fixes all the brokeness in my last submission. It
> compiles cleanly with tape support on or off. I added a couple of #ifdef's
> and removed the broken macro definition. The #ifdef's made it unneccesary.
> It also replaces create_proc_read_entry with proc_create.
> 
> This patch allows us to display information about all of the logical volumes
> configured on a particular controller without stepping on memory even when
> there are many volumes (128 or more) configured.
> Please consider this for inclusion.

Looks a lot better, I've applied it.

-- 
Jens Axboe


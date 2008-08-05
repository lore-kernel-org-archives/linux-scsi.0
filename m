From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Date: Tue, 5 Aug 2008 15:30:12 -0700
Message-ID: <20080805153012.0076396e.akpm@linux-foundation.org>
References: <20080730211842.GF1758@roadking.ldev.net>
	<20080804095633.GA20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196AbYHEWab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 18:30:31 -0400
In-Reply-To: <20080804095633.GA20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: mike.miller@hp.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 4 Aug 2008 11:56:33 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Jul 30 2008, Mike Miller wrote:
> > Patch 6 of 6
> > 
> > Bug fix. If SCSI tape support is turned off we get an implicit declaration
> > of cciss_unregister_scsi error in cciss_remove_one.
> > Please consider this for inclusion.
> 
> Applied 1-6, thanks.

I'm not seeing these changes in linux-next nor in
master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-next
nor in #for-akpm.

Also, #for-next is empty, but #for-akpm has the single commit

    commit 7b87c0541a2d606c0b1a47fa8afbaeb32fad6d60
    Author: Jens Axboe <jens.axboe@oracle.com>
    Date:   Wed Jun 25 12:04:48 2008 +0200

        vmsplice: implement real vmsplice to userspace


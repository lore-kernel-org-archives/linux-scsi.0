From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Wed, 29 Oct 2014 19:41:31 +0100
Message-ID: <20141029184131.GB11153@lst.de>
References: <1414432746-12888-1-git-send-email-hch@lst.de> <1414432746-12888-3-git-send-email-hch@lst.de> <544F5C5C.3090104@acm.org> <20141028173926.GB22593@lst.de> <5450C7AA.40706@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40747 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaJ2Sle (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 14:41:34 -0400
Content-Disposition: inline
In-Reply-To: <5450C7AA.40706@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On Wed, Oct 29, 2014 at 11:55:38AM +0100, Bart Van Assche wrote:
> As you know I'm working on several different projects simultaneously so I'm 
> not sure I will be able to free up some time soon to work on this. I will 
> add this on my to-do list but if anyone else would like to start working on 
> this that would be welcome.

I don't think this is an urgent one - so far no one ran into actual issue
due to it.  I'd still love to see it addressed eventually by someone.


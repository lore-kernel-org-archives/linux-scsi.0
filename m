From: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.17-mm5
Date: Sat, 1 Jul 2006 18:54:48 -0400
Message-ID: <20060701225448.GB12703@havoc.gtf.org>
References: <20060701033524.3c478698.akpm@osdl.org> <20060701142419.GB28750@tlg.swandive.local> <20060701143047.b3975472.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:35285 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751368AbWGAWzO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2006 18:55:14 -0400
Content-Disposition: inline
In-Reply-To: <20060701143047.b3975472.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Grant Wilson <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-scsi@vger.kernel.org

On Sat, Jul 01, 2006 at 02:30:47PM -0700, Andrew Morton wrote:
> Grant Wilson <grant.wilson@zen.co.uk> wrote:
> > [  155.226233] Oops: 0000 [1] PREEMPT SMP 

Also, would be nice to re-test without preempt.

Disabling preempt _continues_ to fix (bandaid?) problems...

	Jeff




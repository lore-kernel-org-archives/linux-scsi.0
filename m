From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 06/12] iscsi-target: Add iSCSI Login Negotiation and
	Parameter logic
Date: Tue, 15 Mar 2011 15:55:19 -0700
Message-ID: <1300229719.28255.314.camel@haakon2.linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-7-git-send-email-nab@linux-iscsi.org>
	 <20110315102146.GA24496@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110315102146.GA24496@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-03-15 at 11:21 +0100, Christoph Hellwig wrote:
> The thread pool in iscsi_thread_queue.c looks like it really should
> go away in favour of the new concurrency managed workqueues.

Yes, this code has been around for some time..

> Did you look into the current kernel kernel/workqueue.c code?
> 

I was thinking more about this for target core v4.1 / .40 stuff, but
have not looked at this for iSCSI target not just yet..

I think this would be a good fit for immediate and response queues in
iscsi_target_tx_thread(), and I think we could convert with fairly
minimal breakage to the existing code if I understand Tejun's new model
correct.  I need to read-up a bit more before jumping on this
conversion, but if you want to do an initial conversion I would be happy
to merge it and help with the polish while I address your other
comments.

--nab

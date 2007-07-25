From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Wed, 25 Jul 2007 17:42:58 +0900
Message-ID: <20070725174258T.fujita.tomonori@lab.ntt.co.jp>
References: <46A60633.2020904@panasas.com>
	<1185293406.3488.5.camel@localhost.localdomain>
	<46A70944.6030005@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41651 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXGYIn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 04:43:27 -0400
In-Reply-To: <46A70944.6030005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bhalevy@panasas.com
Cc: James.Bottomley@SteelEye.com, tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
Date: Wed, 25 Jul 2007 11:26:44 +0300

> > However, I'm perfectly happy to go with whatever the empirical evidence
> > says is best .. and hopefully, now we don't have to pick this once and
> > for all time ... we can alter it if whatever is chosen proves to be
> > suboptimal.
> 
> I agree.  This isn't a catholic marriage :)
> We'll run some performance experiments comparing the sgtable chaining
> implementation vs. a scsi_data_buff implementation pointing
> at a possibly chained sglist and let's see if we can measure
> any difference.  We'll send results as soon as we have them.

I did some tests with your sgtable patchset and the approach to use
separate buffer for sglists. As expected, there was no performance
difference with small I/Os. I've not tried very large I/Os, which
might give some difference.

The patchset to use separate buffer for sglists is available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git simple-sgtable


Can you clean up your patchset and upload somewhere?

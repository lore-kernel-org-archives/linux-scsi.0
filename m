From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/2] dm: Avoid use-after-free of a mapped device
Date: Tue, 26 Feb 2013 09:30:57 +0900
Message-ID: <512C0241.7050500@ce.jp.nec.com>
References: <51274C2F.6070500@acm.org> <51274CC3.9070204@acm.org> <512B339A.7010606@ce.jp.nec.com> <512B7EC0.8090400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:42876 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab3BZAcq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 19:32:46 -0500
In-Reply-To: <512B7EC0.8090400@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

On 02/26/13 00:09, Bart Van Assche wrote:
> Without your patch my test failed after two or three iterations. With your patch my test is still running after 53 iterations. So if you want you can add Tested-by: Bart Van Assche <bvanassche@acm.org>.

Great. Thanks for testing.
I'll submit a patch with your Reported-by and Tested-by.

> Your e-mail and the above patch are also interesting because these explain why reverting to the v3.7 of drivers/md made my test succeed.
> 
> Note: even if this patch gets accepted I think it's still useful to modify blk_run_queue() such that it converts recursion into iteration.

Yes. That's a separate discussion.
Though I'm not sure if it's ok in general to implicitly convert
sync run-queue to async one.

-- 
Jun'ichi Nomura, NEC Corporation


From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH resend] scsi: convert discard to REQ_TYPE_FS from  REQ_TYPE_BLOCK_PC
Date: Tue, 20 Jul 2010 20:00:02 -0600
Message-ID: <4C4654A2.3010904@kernel.dk>
References: <20100721102855Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50113 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762002Ab0GUCAK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 22:00:10 -0400
In-Reply-To: <20100721102855Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, hch@lst.de, snitzer@redhat.com, linux-scsi@vger.kernel.org

On 07/20/2010 07:29 PM, FUJITA Tomonori wrote:
> Jens, any reason why this isn't included in your for-2.6.36 yet?

Oversight, included now.

-- 
Jens Axboe


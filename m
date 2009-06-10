From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for potential
 bio leak"
Date: Wed, 10 Jun 2009 11:34:28 +0300
Message-ID: <4A2F7014.2030705@panasas.com>
References: <4A2E645F.9090008@panasas.com>	<20090610080039B.fujita.tomonori@lab.ntt.co.jp>	<4A2F6B8E.8060700@panasas.com> <20090610172956C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:7642
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757322AbZFJIe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 04:34:28 -0400
In-Reply-To: <20090610172956C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 06/10/2009 11:29 AM, FUJITA Tomonori wrote:
> 
> Read the code. I think that you totally misunderstand these functions.
> 

Thanks for the detail explanation. This really help me a lot

Boaz

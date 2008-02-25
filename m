From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 2/2] ps3rom: Simplify fill_from_dev_buffer()
Date: Tue, 26 Feb 2008 00:39:34 +0900
Message-ID: <20080224235154E.tomof@acm.org>
References: <1203895523-4009-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0802251420270.31208@vixen.sonytel.be>
	<Pine.LNX.4.64.0802251423470.31208@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58328 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbYBYPk2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 10:40:28 -0500
In-Reply-To: <Pine.LNX.4.64.0802251423470.31208@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com

On Mon, 25 Feb 2008 14:24:31 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Subject: [PATCH] ps3rom: Simplify fill_from_dev_buffer()
> 
> As we no longer need to calculate the data length of the whole scatterlist,
> we can abort the loop earlier and coalesce req_len and act_len into one
> variable, making fill_from_dev_buffer() more similar to fetch_to_dev_buffer().

I'll add new APIs to copy data between a sg list and a buffer soon
after cleaning up (and fixing) some drivers on this area. I plan to
remove fill_from_dev_buffer and fetch_to_dev_buffer in ps3rom. As you
know, they are same functions that scsi_debug uses. There are other
drivers that need similar functions. I expect my ps3rom patch to be
applied to the scsi-fixes tree so I didn't change much as you did in
this patch.

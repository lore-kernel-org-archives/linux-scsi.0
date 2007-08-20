From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] add use_sg_chaining option to scsi_host_template
Date: Mon, 20 Aug 2007 09:11:28 +0200
Message-ID: <20070820071128.GP23758@kernel.dk>
References: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26952 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbXHTHLb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2007 03:11:31 -0400
Content-Disposition: inline
In-Reply-To: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Fri, Aug 17 2007, FUJITA Tomonori wrote:
> This is for Jens' sglist branch in the block git tree.
> 
> It enables sg chaining support for the LLDs that use scsi_for_each_sg
> accessor properly.
> 
> ---
> From a6e50a3b476bc193de103e8c1d95877ced38918e Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Fri, 17 Aug 2007 01:35:41 +0900
> Subject: [PATCH] add use_sg_chaining option to scsi_host_template
> 
> This option is true if a low-level driver can support sg
> chaining. This will be removed eventually when all the drivers are
> converted to support sg chaining. q->max_phys_segments is set to
> SCSI_MAX_SG_SEGMENTS if false.

This looks good to me. I'd normally complain about the silly
ENABLE_SG_CHAINING defines (just use 0/1), but since this is a short
term approach, it's fine with me.

-- 
Jens Axboe


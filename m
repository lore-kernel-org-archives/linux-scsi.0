From: "adam radford" <aradford@gmail.com>
Subject: Re: [PATCH] 3w-xxxx: remove unnecessary local_irq_save/restore for scsi sg copy API
Date: Fri, 10 Oct 2008 12:43:09 -0700
Message-ID: <b1bc6a000810101243n59644f4cqfdc8b702ece2c765@mail.gmail.com>
References: <20081009112510D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58388 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676AbYJJTnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Oct 2008 15:43:11 -0400
Received: by gxk9 with SMTP id 9so1239681gxk.13
        for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2008 12:43:09 -0700 (PDT)
In-Reply-To: <20081009112510D.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Adam Radford <linuxraid@amcc.com>

On Wed, Oct 8, 2008 at 7:25 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> Since the commit 50bed2e2862a8f3a4f7d683d0d27292e71ef18b9 (sg: disable
> interrupts inside sg_copy_buffer), no need to disable interrupts
> before calling scsi_sg_copy_from_buffer. So we can simplify
> tw_transfer_internal, which disables interrupts just for
> scsi_sg_copy_from_buffer.

Thanks for the patch.  Looks like we will need a similar one for the 3w-9xxx
driver.

-Adam

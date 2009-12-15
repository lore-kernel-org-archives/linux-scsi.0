From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: query regarding command conversion
Date: Tue, 15 Dec 2009 15:02:01 +0200
Message-ID: <4B2788C9.9070003@panasas.com>
References: <9ff69a5d0912150356w583bfdefs1a9046842609cfba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52629 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbZLONCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 08:02:10 -0500
Received: by fxm21 with SMTP id 21so4333918fxm.21
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2009 05:02:08 -0800 (PST)
In-Reply-To: <9ff69a5d0912150356w583bfdefs1a9046842609cfba@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prashant Bhole <prashantsmailcenter@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 12/15/2009 01:56 PM, Prashant Bhole wrote:
> Hi,
> I have a SATA disk which is represented by node /dev/sdb.
> I opened that device using open_blk_excl() to perform IO from a kernel module.
> IO request is submitted using generic_make_request() which is in terms
> of struct bio.
> As per my knowledge LLDs do not deal with struct bio.
> 
> My question is, where does the struct bio to struct scatterlist
> conversion takes place
> before SCSI layer calls hostt->queuecommand()?
> 
> Thanks,

It is done in scsi_init_sgtable() scsi_lib.c. As part of scsi's prep_fn

Boaz

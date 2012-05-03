From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: RE [PATCH] pm8001: support HDA (flashless) mode (take 2)
Date: Thu, 3 May 2012 13:18:08 -0400
Message-ID: <4300E2A0-D9C8-44AB-B0F0-CD1945A6D2E6@xyratex.com>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com> <C1F230B3-E151-495B-99A0-88739ACBBFCF@xyratex.com> <2275E35DFBB74B10B6049A728D6F46E3@usish.com.cn>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:43461 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752313Ab2ECRSP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 May 2012 13:18:15 -0400
In-Reply-To: <2275E35DFBB74B10B6049A728D6F46E3@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org, 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?utf-8?B?J+S6jueIseWNjic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

I had viewed the hot-plug changes as separate (I see now that was a bogus distinction), I will merge them in.

Yes, the check_fw_ready is not needed, but was left in as an attempt to not touch the 'good path' for the other modes, I saw it as it could not hurt. I will test without it, and ensure operation in both our upstream code (?) and the kernel.org patch to be 100% sure. I was admittedly paranoid about removing that one. I had been experimenting and thinking about this one ever since Take-2 left the gate and am not yet satisfied.

I appreciate the comments, a sign of a deep dive into this one! Thanks!

Take-3 will arrive after testing, I will send you a PM preview to confirm ...

Sincerely -- Mark Salyzyn

On May 2, 2012, at 8:35 PM, Jack Wang wrote:

> Hi Mark,
> 
> I found other issue in this patch need to be addressed. when HDA mode is
> enable, we need also change the soft reset signature to HDA signature in
> pci_remove/suspend/resume function.
> 
> and in pm8001_chip_init, check fw ready is not need for HDA mode.
> 
> 
> Best regards
> 
> Jack
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] scsi_tgt_lib: Use scsi_init_io instead of
 scsi_alloc_sgtable
Date: Thu, 08 Nov 2007 12:13:21 +0900
Message-ID: <20071108121321F.fujita.tomonori@lab.ntt.co.jp>
References: <4730ACAA.2060007@panasas.com>
	<4730AF73.7010009@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:64181 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbXKHD0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 22:26:49 -0500
In-Reply-To: <4730AF73.7010009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com

On Tue, 06 Nov 2007 20:16:19 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
>   - If we export scsi_init_io()/scsi_release_buffers() instead of
>     scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
>     much more insulated from scsi_lib changes. As a bonus it will
>     also gain bidi capability when it comes.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Looks good for me except for this:

./scripts/checkpatch.pl ~/Mail/kernel/scsi/28814
ERROR: use tabs not spaces
#101: FILE: drivers/scsi/scsi_lib.c:741:
+                                              gfp_t gfp_mask)$

total: 1 errors, 0 warnings, 144 lines checked



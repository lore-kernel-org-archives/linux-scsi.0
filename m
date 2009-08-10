From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [patch 04/11] scsi: add __init/__exit macros to ibmvstgt.c
Date: Tue, 11 Aug 2009 08:52:06 +0900
Message-ID: <20090811085112K.fujita.tomonori@lab.ntt.co.jp>
References: <200908062309.n76N9Mft011503@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45964 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZHJXxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 19:53:01 -0400
In-Reply-To: <200908062309.n76N9Mft011503@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, peterhuewe@gmx.de, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au

On Thu, 06 Aug 2009 16:09:22 -0700
akpm@linux-foundation.org wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Add the __init and __exit macros to the module_init / module_exit
> functions from drivers/scsi/ibmvscsi/ibmvstgt.c
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Thanks,

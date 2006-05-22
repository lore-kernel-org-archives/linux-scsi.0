From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] scsi tgt: ibmvstgt driver
Date: Tue, 23 May 2006 01:53:45 +0900 (JST)
Message-ID: <20060523015029Y.fujita.tomonori@lab.ntt.co.jp>
References: <20060429155926B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:45715 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750985AbWEVQxx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:53:53 -0400
In-Reply-To: <20060429155926B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] scsi tgt: ibmvstgt driver
Date: Sat, 29 Apr 2006 15:59:37 +0900 (JST)

> This is IBM Virtual SCSI target driver for tgt.
> 
> This patch dependents on the previous patch to convert the ibmvscsi
> driver to use include/scsi/srp.h.
> 
> The driver is based on the original ibmvscsis driver:
> 
> http://lkml.org/lkml/2005/10/17/99
> 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Thanks for merging this (and sorry about the complie error).  Seems
that you forgot to merge the ibmvstgt driver
(drivers/scsi/ibmvscsi/ibmvstgt.c).

We have one more issue with this. It depends on the viosrp change:

http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=%20ef265673434680f2307ceafae4a2badc657e94cc



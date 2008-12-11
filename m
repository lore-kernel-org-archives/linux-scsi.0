From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Fri, 12 Dec 2008 01:08:05 +0900
Message-ID: <20081212010845L.fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55136 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbYLKQIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 11:08:24 -0500
In-Reply-To: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

On Thu, 11 Dec 2008 23:07:37 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patchset is the second half of the patchset to remove
> scsi_execute_async in st driver. IOW, this converts st driver to use
> the block layer functions.

Forgot to say, this patchset can be applied to James' scsi-misc git tree.

Thanks,

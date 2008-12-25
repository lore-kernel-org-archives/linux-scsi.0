From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 00/16] st: remove scsi_execute_async usage (the
 second half)
Date: Thu, 25 Dec 2008 23:51:41 +0900
Message-ID: <20081225235112T.fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37232 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYLYOwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Dec 2008 09:52:00 -0500
In-Reply-To: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, 18 Dec 2008 14:49:35 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patchset is the second version of the second half patchset to
> remove scsi_execute_async in st driver (IOW, this converts st driver
> to use the block layer functions).
> 
> http://marc.info/?l=linux-scsi&m=122900494917385&w=2
> 
> I've not changed the st patches much since the first version. No
> change to the #4-14 st patches except for cleanups to silence
> checkpatch.sh. The new #15-16 patches for st came from Kai, who
> greatly helped me out with this patchset.

Kai, can I get your ACK on these patches?

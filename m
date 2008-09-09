From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/8] sg cleanup patches after the block conversion
Date: Tue, 9 Sep 2008 22:35:31 +0900
Message-ID: <20080909223555K.fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38660 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYIINgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2008 09:36:44 -0400
In-Reply-To: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Tue,  2 Sep 2008 22:50:00 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Here's some cleanup patches, removing functions that became
> unnecessary after the block conversion, functions used temporally
> during the conversion, etc.
> 
> This is against the for-2.6.28 brach in the block tree:

Jens, can you apply this to your for-2.6.28?

Thanks,

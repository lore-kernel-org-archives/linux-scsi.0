From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Sat, 16 Jan 2010 20:47:51 +0900
Message-ID: <20100116204714U.fujita.tomonori@lab.ntt.co.jp>
References: <20100115081030.GZ13771@kernel.dk>
	<tkrat.956a5012a91df155@s5r6.in-berlin.de>
	<20100115214455.GG13413@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54516 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab0APLwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jan 2010 06:52:40 -0500
In-Reply-To: <20100115214455.GG13413@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: stefanr@s5r6.in-berlin.de, jens.axboe@oracle.com, dgilbert@interlog.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 15 Jan 2010 15:44:55 -0600
scameron@beardog.cce.hp.com wrote:

> I've since tried this on a newer kernel, 2.6.33rc4 (previously I 
> was using a 2.6.27 kernel). 
> 
> With the 2.6.33rc4 kernel, so far the problem hasn't appeared. 

Some race bugs about device removal that might be related with this
issue were fixed around 2.6.30, I think.

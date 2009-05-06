From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] 3ware scsi_dma_unmap fix
Date: Wed, 6 May 2009 09:33:45 +0900
Message-ID: <20090506093400K.fujita.tomonori@lab.ntt.co.jp>
References: <b1bc6a000905051145s411cea22r7decd68bac687bb8@mail.gmail.com>
	<20090506091238I.fujita.tomonori@lab.ntt.co.jp>
	<b1bc6a000905051725y167f6b67pa243807954eda78a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [192.16.179.4] ([192.16.179.4]:47143 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZEFAfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2009 20:35:55 -0400
In-Reply-To: <b1bc6a000905051725y167f6b67pa243807954eda78a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aradford@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Tue, 5 May 2009 17:25:40 -0700
adam radford <aradford@gmail.com> wrote:

> I wouldn't do that.  The generic_buffer_virt stuff is there because
> the hardware can't DMA < 512 bytes, so we sg_copy_to/from_buffer()
> there, then dma from generic_buffer_virt.

Thanks, I see. Yeah, if the hardware can't DMA < 512 bytes, the driver
needs such workaround.

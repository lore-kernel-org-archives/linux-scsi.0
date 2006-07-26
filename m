From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Wed, 26 Jul 2006 02:20:06 +0100
Message-ID: <1153876807.7559.39.camel@localhost>
References: <NONAMEBFJ3sl3xbYiMC000000d4@nonameb.ptu.promise.com>
	 <20060725092656.GA28195@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:29831 "EHLO
	out.lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1030294AbWGZAS7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 20:18:59 -0400
In-Reply-To: <20060725092656.GA28195@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch <hch@infradead.org>
Cc: Ed Lin <ed.lin@promise.com>, linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>, jeff <jeff@garzik.org>

On Maw, 2006-07-25 at 10:26 +0100, hch wrote:
> We have more than enough precedence for poking the bridge that comes as
> part of addon cards.  As long as the code makes sure it never pokes a bridge
> of the same type that is not on the card (and I don't have the code in front
> of me right now to check whether it's true) we can keep this code.  Please
> make sure to add a big comment that explains what is going on in detail
> and why it's okay in this special case.

It does check the basic layout so looks robust. Checking subvendor stuff
is normally a good back-up. We do similar plumbing work in the Promise
IDE and I2O code to handle the old SuperTrak/SX6000 cards and it work
solidly.

Alan


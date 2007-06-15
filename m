From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 14:55:59 -0700 (PDT)
Message-ID: <20070615.145559.88477207.davem@davemloft.net>
References: <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615.141720.112626963.davem@davemloft.net>
	<467309BA.8000009@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50995
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756722AbXFOVzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 17:55:41 -0400
In-Reply-To: <467309BA.8000009@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 15 Jun 2007 17:50:50 -0400

> FWIW that's why libata followed the path it did:  faking SCSI required 
> the least amount of code for the maximal amount of existing storage 
> driver and platform installer support.
> 
> Well, that and the fact that ATAPI is really SCSI, but that's offtopic 
> for this thread.  :)

Yep I absolutely understand that, and for my case as well it's
nearly always SCSI underneath that's why you can send SCSI
commands passthru to the virtual disk server if you like.

From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [REPOST #1] Regression in 2.6.15 w.r.t Promise SATA 300 TX2Plus
 support
Date: Fri, 03 Feb 2006 17:47:04 -0500
Message-ID: <43E3DD68.3020303@pobox.com>
References: <BAY103-F103F1EE10E26F5825B0763AB0D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:51143 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750863AbWBCWrJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2006 17:47:09 -0500
In-Reply-To: <BAY103-F103F1EE10E26F5825B0763AB0D0@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ranjeet Shetye <rshetye@hotmail.com>
Cc: linux-scsi@vger.kernel.org

Ranjeet Shetye wrote:
> hi,
> 
> I have a Promise SATA 300 TX2plus card in my linux server (2 SATA ports, 
> 1 PATA port).
> 
> The 2.6.14 (archck7) kernel would not recognize the card, so I used 
> lspci to find the device ID and I made the following change to 
> sata_promise.c

PATA has never been supported in the upstream kernel, always via a 
patch.  You lost a patch somewhere.

	Jeff




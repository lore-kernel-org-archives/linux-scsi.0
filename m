From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: SATA status report updated
Date: Mon, 22 Aug 2005 00:00:44 +0200
Message-ID: <4308F98C.8060506@danbbs.dk>
References: <42FC2EF8.7030404@pobox.com> <4308B5C1.2040304@danbbs.dk> <4308C287.6020603@pobox.com>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepb.post.tele.dk ([195.41.46.236]:21529 "EHLO
	pfepb.post.tele.dk") by vger.kernel.org with ESMTP id S1751168AbVHUWAX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 18:00:23 -0400
In-Reply-To: <4308C287.6020603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Mogens Valentin wrote:
> 
>> Jeff, is it possible for you at this time to comment on support for 
>> the JMicron JMB360 sataII chip?  Possible timeframe?
> 
> Never heard of it.

Neigher had I. It's being used on the ASrock 939-SATAII mobo, in 
conjunction with the ULi M1695 chipset. I wonder why they chose an 
unknown SATAII chip for this. The M1695 already has two SATA150 
interfaces, and the only test I've seen with SATAII on this mobo used a 
SATA150 disk on that JMB360 interface - with poorer results than on the 
regular ifc. Could be due to the chip, BIOS, (xp) driver...

The rest of the tests came out pretty good, and the board is well 
featured, so naturally I'm interested in possible libata support.

-- 
Kind regards,
Mogens Valentin


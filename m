From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Tue, 03 Oct 2006 22:29:05 -0400
Message-ID: <45231C71.2060306@torque.net>
References: <20061003205237.18125.qmail@web31803.mail.mud.yahoo.com> <4522D3C0.6060706@garzik.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18844 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030725AbWJDC23 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 22:28:29 -0400
In-Reply-To: <4522D3C0.6060706@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: ltuikov@yahoo.com, James Bottomley <James.Bottomley@SteelEye.com>, Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Luben Tuikov wrote:
>> You have to make a clarification: "the way event processing works" means
>> the way it works after you removed all of event processing from my
>> code the
>> way I wrote it, and added a very naive "event processing" if it can be
>> called that.
>>
>> Event processing seems to work just fine with my version of my code the
>> way I maintain it, and the way you had it originally on this list.
>>
>> Just clarifying in case someone gets confused reading the code.
> 
> And we were all waiting breathlessly for this clarification too, I
> assure you.
> 
> In the dictionary under the phrase "sore loser", it says "see: Luben"

I work with both drivers and provide feedback to their
maintainers. IMO the loser is "linux".

One handicap the official driver has is the SATL it has
decided to use.

... back to my redmond os for testing ...

Doug Gilbert



From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Tue, 03 Oct 2006 17:18:56 -0400
Message-ID: <4522D3C0.6060706@garzik.org>
References: <20061003205237.18125.qmail@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50306 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030468AbWJCVTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2006 17:19:03 -0400
In-Reply-To: <20061003205237.18125.qmail@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> You have to make a clarification: "the way event processing works" means
> the way it works after you removed all of event processing from my code the
> way I wrote it, and added a very naive "event processing" if it can be
> called that.
> 
> Event processing seems to work just fine with my version of my code the
> way I maintain it, and the way you had it originally on this list.
> 
> Just clarifying in case someone gets confused reading the code.

And we were all waiting breathlessly for this clarification too, I 
assure you.

In the dictionary under the phrase "sore loser", it says "see: Luben"

	Jeff



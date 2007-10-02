From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix SSP IU status print-out
Date: Tue, 02 Oct 2007 10:48:46 -0400
Message-ID: <47025A4E.6040200@garzik.org>
References: <20070930140317.GA7134@havoc.gtf.org>	 <4702399A.9010708@garzik.org>	 <1191334857.3530.39.camel@localhost.localdomain>	 <47025743.3070100@garzik.org> <1191336373.3530.62.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:32791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXJBOss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 10:48:48 -0400
In-Reply-To: <1191336373.3530.62.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-10-02 at 10:35 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Tue, 2007-10-02 at 08:29 -0400, Jeff Garzik wrote:
>>>> James, what is the upstream status of my two aic94xx bug fixes?
>>>>
>>>> Have they been sent to Linus yet?
>>>>
>>>> Since you seem M.I.A., I'll send them upstream if I do not hear from you 
>>>> today.
>>> They're hardly -rc8 critical bug fixes, since no-one has noticed their
>>> effects for about 5 kernel releases.  I'll stick them into scsi-misc
>>> with the rest of the pending stuff.
>> Except for those people who want SMP to work, on platforms where 
>> TODEVICE actually matters.
> 
> And the number of bug reports on this?
> 
>> I'll send them upstream myself.
> 
> No, you won't; because that would be completely irresponsible.  You
> don't turn code for no reason at the last minute unless it's essential
> because of the danger of introducing inadvertent bugs along with the
> changes.  Since there are no users affected, there's zero benefit and
> there is a potential non-zero detriment to the code turn.
> 
> There's absolutely no reason to rush these into the release at the last
> minute.  The correct path is via scsi-misc and then to be backported
> into the stable series once we're sure they're OK.

What's irresponsible is holding onto simple, obvious bug fixes that 
obviously break certain scenarios.

	Jeff




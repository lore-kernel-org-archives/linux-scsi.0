From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: WARNING : kernel 2.6.11.7 (others) kills megaraid 4e/Si dead
Date: Tue, 05 Jul 2005 17:52:03 +0300
Message-ID: <42CA9E93.1050802@mandriva.org>
References: <20050503151532.GA1316@thumper2> <20050503190005.GS23013@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mbox1.netikka.net ([213.250.81.202]:52710 "EHLO
	mbox1.netikka.net") by vger.kernel.org with ESMTP id S261868AbVGEOwE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2005 10:52:04 -0400
In-Reply-To: <20050503190005.GS23013@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Chris Wright wrote:
> * Andy (genanr@emsphone.com) wrote:
> 
>>cross posted due to the severity of this issue.
>>
>>I have killed two Dell 1850 (x86_64) with megaraid 4e/SI servers using
>>kernel 2.6.11.7.  When the system boots, it looks like it does not see the
>>megaraid controller (because it never prints anything about it) and hangs
>>when it tries to mount root.  When rebooted, the system says no firmware
>>present for embedded raid controller.  I then try to flash it, the flash
>>program says the firmware is corrupt and flashes the controller.  However,
>>upon reboot I still get the no firmware present, thus the machine can no
>>longer boot off the raid.
> 
> 
> Not good.  There were no megaraid changes in the -stable series.  What's
> the last kernel.org kernel that worked for you?
> 


Any news on this matter?
I hvr a PE1850 waiting for kernel upgrade, but I'm afraid to do so now...

I can't break my box with tests since it's in active use...
For now I'm running a 2.6.8.1 based kernel on the box...


--
Regards

Thomas

PS.
Please CC me as I'm not subscribed...


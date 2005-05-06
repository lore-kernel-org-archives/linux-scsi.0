From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: WARNING : kernel 2.6.11.7 (others) kills megaraid 4e/Si dead
Date: Sat, 07 May 2005 01:08:31 +0300
Message-ID: <427BEADF.9040606@mandriva.org>
References: <20050503151532.GA1316@thumper2> <20050503190005.GS23013@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mbox1.netikka.net ([213.250.81.202]:13992 "EHLO
	mbox1.netikka.net") by vger.kernel.org with ESMTP id S261303AbVEFWIa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2005 18:08:30 -0400
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

Any news on this ??

I'm about to load linux on one PE1850 and two PE2850 with that
controller, but now I'm afraid of doing so...

--
Regards

Thomas

PS. Please CC me as I'm not subscribed...


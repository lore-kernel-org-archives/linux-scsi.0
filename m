From: Joshua Schmidlkofer <joshua@imrlive.com>
Subject: Re: Recurring MegaRAID SCSI Errors
Date: Fri, 20 Oct 2006 06:53:18 -0700
Message-ID: <4538D4CE.5040607@imr-net.com>
References: <890BF3111FB9484E9526987D912B261932E3F9@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from commie.imr-net.com ([65.182.241.242]:18385 "EHLO
	commie.imr-net.com") by vger.kernel.org with ESMTP id S2992612AbWJTNxY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 09:53:24 -0400
Received: from commie.imr-net.com (localhost.localdomain [127.0.0.1])
	by commie.imr-net.com (Postfix) with ESMTP id 1CCCC200FF62F
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 06:53:24 -0700 (PDT)
In-Reply-To: <890BF3111FB9484E9526987D912B261932E3F9@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Joshua Schmidlkofer <jms@dev.imr-net.com>, Mike Montagne <mike@opsisarch.com>

Ju, Seokmann wrote:
> Hi,
>   
>> [17333187.152000] megaraid: aborting-6172714 cmd=2a <c=2 t=1 l=0>
>> [17333187.152000] megaraid abort: 6172714:124[255:129], fw owner
>> [17333187.152000] megaraid: 15 outstanding commands. Max wait 300 sec
>> [17333187.152000] megaraid mbox: Wait for 15 commands to complete:300
>> [17333192.172000] megaraid mbox: Wait for 10 commands to complete:295
>> [17333197.192000] megaraid mbox: Wait for 3 commands to complete:290
>> [17333199.200000] megaraid mbox: reset sequence completed sucessfully
>>     
> Above messages indicate that,
> - there are commands (mostly WRITE(10)) pending in MegaRAID F/W taking longer than given timeout period.
> - After driver waitinf for 10 seconds, all of those commands had been returned successfully.
> - So, the driver returned back to normal operation.
>
> There is NO data loss/integrity error related to this messages as driver returned back to normal successfully.
> Howerver, to get rid of those messages, I would like to ask you to check and upgrade F/W image on the controllers, first.
>
> Thank you,
>
> Seokmann
>   
Seokmann,

   Thank you for your reply.  This makes me feel _much_ better. =).  We 
have verified all the firmware levels except the PowerVault 220 external 
chassis.  We have only hit this error with external devices, and since 
we went ot the PV220 from an older chassis it has continued. (All new 
controllers, system and motherboard, but the same Debian Install w/ a 
newer kernel).   We have scheduled outage this weekend to down the 
server  and then use the diagnostic tools to check/update the firmware 
inside the PowerVault.

   Since we have brand-new hardware all over - do you have any other 
recommendations about what, if anything, further could be done, if the 
firmware is confirmed up to date?


Sincerely,
  Joshua

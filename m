From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: legacy megaraid status
Date: Thu, 29 Sep 2005 20:18:54 -0700
Message-ID: <FE3BEDDA06FC32CE9C660FBE@[10.170.7.6]>
References: <433175AE.5070905@darthvader.us>
 <30E6DB5A16C820CE29D97507@[10.169.6.233]> <4332705E.6030905@darthvader.us>
 <C2A6572782C9593467A750C4@[10.169.6.233]>
 <43330F6E.9070303@shadowconnect.com> <4333CC60.4000705@darthvader.us>
 <FE99409D46B528642AB32FAA@[10.169.6.233]> <433AA91F.7030403@darthvader.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segw.microprecisionautomation.com ([69.17.55.168]:49874 "EHLO
	segw.microprecisionautomation.com") by vger.kernel.org with ESMTP
	id S1751361AbVI3DTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 23:19:04 -0400
In-Reply-To: <433AA91F.7030403@darthvader.us>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Yiannis Mavroukakis <jander@darthvader.us>

--On Wednesday, September 28, 2005 3:30 PM +0100 Yiannis Mavroukakis 
<jander@darthvader.us> wrote:

>>> However I am not quite about the SSID..Is this the Subsystem hex lspci
>>> reports?
>>
>>
>> I'm not at the machine right now to check, but I recall skimming
>> through the source to the various macros and enumeration code to
>> figure out how this information was extracted.
>
> When you get a moment, if you could point me in the right direction I
> would appreciate it

Took a little backtracking, but look at drivers/pci/probe.c and the symbols 
in pci.h for the offsets in the configuration space.

From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: 2.6.9-rc3-mm3 fails to detect aic7xxx
Date: Thu, 07 Oct 2004 15:49:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165ABE3.8000504@cybsft.com>
References: <1097178019.24355.39.camel@localhost>	<4165A369.60306@cybsft.com> <20041007133956.39c2427e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.utc.com ([192.249.46.193]:64195 "EHLO mail4.utc.com")
	by vger.kernel.org with ESMTP id S269646AbUJGUuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 16:50:05 -0400
In-Reply-To: <20041007133956.39c2427e.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: haveblue@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> "K.R. Foley" <kr@cybsft.com> wrote:
> 
>>Dave Hansen wrote:
>>
>>>I just booted 2.6.9-rc3-mm3 and got the good ol' 
>>>
>>>VFS: Cannot open root device "sda2" or unknown-block(0,0)
>>>Please append a correct "root=" boot option
>>>Kernel panic - not syncing: VFS: Unable to mount root fs on
>>>unknown-block(0,0)
>>>
>>>backing out bk-scsi.patch seems to fix it.  I believe this worked in
>>>2.6.9-rc3-mm2.
>>>
>>>-- Dave
>>
>>While I can't verify that backing out bk-scsi.patch fixes it for me yet, 
>>I can verify that I get the exact same error trying to boot this kernel. 
>>I too am using the aic7xxx.
>>
> 
> 
> Were some earlier messages printed out, during the scsi bringup stage?
> 
> A full dmesg dump would be nice.
> 

Yes it would. Unfortunately I am not near the machine right now. I do 
know that there is not much info being displayed prior to the failure 
message listed above and I don't have a serial console on this system 
currently. I will be glad to try to dig into it further when I get home 
in a few hours.

kr

From: Mark Rustad <mrustad@gmail.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devicedriver for new sequence firmware.
Date: Wed, 7 Feb 2007 16:57:19 -0600
Message-ID: <E933AE1E-B184-4421-B9A4-A2B0851BBC7F@gmail.com>
References: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E7@aime2k302.adaptec.com> <45C997C4.1010705@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:50072 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161471AbXBGW5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 17:57:21 -0500
Received: by wx-out-0506.google.com with SMTP id h31so323312wxd
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2007 14:57:20 -0800 (PST)
In-Reply-To: <45C997C4.1010705@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

On Feb 7, 2007, at 3:11 AM, Darrick J. Wong wrote:

> Wu, Gilbert wrote:
>> Hi James,
>>
>>   We are investigating this issue here. We will update the status  
>> when
>> we can duplicate the problem here and root cause.
>
> FWIW,
>
> v17 looks good for both SAS/SATA load testing.  The 24-disk x260 seems
> to have crapped out after about 800 rounds of load/unload due to the
> phys reporting devices, then no devices about 10s later, and then  
> having
> the module unloaded before the dead SAS commands finished returning.
> Not sure what that's about, though I might also have borked the  
> x260 :(
>
> Though who really is going to reboot the machine 800 times in rapid- 
> fire
> succession???
>
> (I'm not trying to slam the v28 sequencer, I'm merely providing a
> baseline for comparison between the two.  It may very well be the case
> that all the bugs we used to observe with v17 were merely a result  
> of us
> poking the sequencer the wrong way....)

My understanding is that the new sequencer has moved some registers  
and so each version of the sequencer would have to be run with a  
driver coded for that particular version of the sequencer. If you are  
trying to use the same driver with both versions of the sequencer,  
bad things will happen unless you have a driver that can recognize  
both versions and handle each appropriately. I don't think that the  
aic94xx driver as it exists can do that.

Please excuse me if you were already aware of this, but if you  
weren't I wanted to try to short-circuit some of your head-banging.

-- 
Mark Rustad, MRustad@gmail.com



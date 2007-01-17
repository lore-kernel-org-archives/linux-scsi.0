From: Mark Rustad <mrustad@gmail.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Wed, 17 Jan 2007 10:32:54 -0600
Message-ID: <B7A62A39-ECD0-4A7E-8645-696F9D2F330C@gmail.com>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net>	 <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no>	 <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no>	 <45A81BBF.7050104@us.ibm.com> <45AA4A7B.7070607@scanventure.no>	 <45ABE920.7090304@us.ibm.com>  <45ACDD6A.7040201@scanventure.no> <1168989278.16470.22.camel@alexisLabtop> <45ADFFA8.5040702@scanventure.no>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:28840 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbXAQQdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 11:33:03 -0500
Received: by wx-out-0506.google.com with SMTP id h31so2543267wxd
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2007 08:33:00 -0800 (PST)
In-Reply-To: <45ADFFA8.5040702@scanventure.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarjei Huse <tarjei@scanventure.no>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi@vger.kernel.org, "Tan, Dennis" <Dennis_Tan@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>

On Jan 17, 2007, at 4:51 AM, Tarjei Huse wrote:

> Alexis Bruemmer wrote:
>> Hi Tarjei,
>>
>> I am glad that you a progressing forward!
>>
> Me too :-)
>> <snip>
>>
>>>> Perhaps.  Could you send a full output?  It does not appear that  
>>>> the
>>>> aic94xx driver is loading at all...?
>>>>
>>>>
>>> Duh again. I thought I had added the module to the initrd, but that
>>> didn't happen.
>>>
>>> Ok, I'm one step further. Where can I get the binary firmware the
>>> adapter asks for?
>>>
>>
>> The new sequencer has yet to be posted.  You can, however, use the  
>> old
>> f/w in the meantime by backing out patch #38:
>>
>> http://sweaglesw.net/~djwong/docs/sas_ata-patches/38-aic94xx-v28- 
>> sequencer_2.patch
>>
> Ok, did that. I now manage to load the module after boot when  
> running rmmod aic94xx and then modprobe aic94xx. However, I cannot  
> get it to load the firmware on boot. I've tried modifying the  
> initram-fs image and placing the module in both /lib/firmware/ and / 
> lib/firmware/2.6.20-rc5/ but it seems not to find the firmware  
> (aic94xx-seq.fw) in any of those locations.
>
> If I reload the module after booting, it will find the firmware in / 
> lib/firmware/2.6.20-rc5 without problems.
>
> Any tips?

Your initramfs needs to have hotplug scripts that can handle firmware  
loading. I'm pretty sure that is what is missing, because I just went  
through the same thing with a QLogic FC driver.

-- 
Mark Rustad, MRustad@mac.com



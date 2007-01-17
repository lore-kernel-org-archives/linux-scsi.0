From: Tarjei Huse <tarjei@scanventure.no>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Wed, 17 Jan 2007 11:51:20 +0100
Message-ID: <45ADFFA8.5040702@scanventure.no>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net>	 <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no>	 <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no>	 <45A81BBF.7050104@us.ibm.com> <45AA4A7B.7070607@scanventure.no>	 <45ABE920.7090304@us.ibm.com>  <45ACDD6A.7040201@scanventure.no> <1168989278.16470.22.camel@alexisLabtop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.bergfald.no ([213.158.252.226]:1728 "EHLO
	mail2.bergfald.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbXAQKva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 05:51:30 -0500
In-Reply-To: <1168989278.16470.22.camel@alexisLabtop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Tan, Dennis" <Dennis_Tan@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>

Alexis Bruemmer wrote:
> Hi Tarjei,
>
> I am glad that you a progressing forward!
>   
Me too :-)
> <snip>
>   
>>> Perhaps.  Could you send a full output?  It does not appear that the
>>> aic94xx driver is loading at all...?
>>>
>>>       
>> Duh again. I thought I had added the module to the initrd, but that
>> didn't happen.
>>
>> Ok, I'm one step further. Where can I get the binary firmware the
>> adapter asks for?
>>     
>
> The new sequencer has yet to be posted.  You can, however, use the old
> f/w in the meantime by backing out patch #38:
>
> http://sweaglesw.net/~djwong/docs/sas_ata-patches/38-aic94xx-v28-sequencer_2.patch
>   
Ok, did that. I now manage to load the module after boot when running 
rmmod aic94xx and then modprobe aic94xx. However, I cannot get it to 
load the firmware on boot. I've tried modifying the initram-fs image and 
placing the module in both /lib/firmware/ and /lib/firmware/2.6.20-rc5/ 
but it seems not to find the firmware (aic94xx-seq.fw) in any of those 
locations.

If I reload the module after booting, it will find the firmware in 
/lib/firmware/2.6.20-rc5 without problems.

Any tips?

kind regards,
Tarjei

Any
> Regards,
>
> Alexis
>
>   
>> [    2.119258] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
>> [    2.119335] ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 19 (level,
>> low) -> IRQ 18
>> [    2.119379] aic94xx: found Adaptec AIC-9405W SAS/SATA Host Adapter,
>> device 0000:03:04.0
>> [    2.119382] scsi0 : aic94xx
>> [   12.158371] aic94xx: Failed to load sequencer firmware file
>> aic94xx-seq-v28.bin, error -2
>> [   12.158375] aic94xx: couldn't init seqs for 0000:03:04.0
>> [   12.158376] aic94xx: couldn't init the chip
>>
>> Kind regards,
>> Tarjei
>>
>>
>>     
>>> --D
>>>
>>>       
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     
>
>   


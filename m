From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aacraid and S.M.A.R.T
Date: Thu, 31 Jul 2008 10:05:18 -0400
Message-ID: <4891C69E.9000106@torque.net>
References: <20080730235450.0fcc21a6.sam@home.se> <EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:40619 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYGaOFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 10:05:31 -0400
In-Reply-To: <EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Martin Samuelsson <sam@home.se>, Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <aacraid@adaptec.com>

Mark Salyzyn wrote:
> aacraid driver is not the emulation. The Firmware itself has a SAT 0.9 
> translation layer to the raw SATA drives at the physical transport, the 
> Firmware then deals with all the targets as SCSI representations.

Mark,
Is that SAT interface at the physical transport accessible
to something like smartmontools?

"SAT 0.9 transport layer" does not correspond to any t10 numbering.
Is the "0.9" meant to imply that the implementation is just
shy of compliance to the SAT-1 standard? [Perhaps a version
descriptor in the INQUIRY response answers my question.]

Doug Gilbert


> SMART was supposed to be emulated, but on that old card it was never 
> tested ... make sure you have the latest Firmware on the card just in 
> case something got fixed ...
> 
> Sincerely -- Mark Salyzyn
> 
> On Jul 30, 2008, at 5:54 PM, Martin Samuelsson wrote:
> 
>> Hello list,
>>
>> I have an old Adaptec 2610SA SATA RAID controller with six disks. As 
>> I'm a bit curious, I'd like to know, for example, the temperature they 
>> report. (afacli can't report those, and I suspect aaccli can't either) 
>> It seemed utterly impossible until I saw the expose_physicals module 
>> option, but after switching that on, I can at least see traces of the 
>> individual disks.
>>
>> If I understand it correctly, aacraid provides an emulation layer 
>> between what I see and the physical disks, passing known commands and 
>> responses back and forth. However, S.M.A.R.T commands doesn't seem to 
>> be among those known ones, is that correct?
>>
>> I'm running CentOS 5 with kernel 2.6.18, which is kind of old. Would 
>> running a spanking new kernel make me happier and support reading the 
>> temperature from the individual disks?
>>
>> Regards,
>> /Sam
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


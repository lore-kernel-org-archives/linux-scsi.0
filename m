From: Aravind Parchuri <aravind.parchuri@gmail.com>
Subject: Re: Please help if u can.
Date: Wed, 21 Feb 2007 14:56:22 -0800
Message-ID: <45DCCE16.7010708@gmail.com>
References: <45DB9D89.7030804@tlchosting.com> <45DBD6CF.7010309@torque.net> <45DBE495.6050706@us.ibm.com> <45DC9053.10908@tlchosting.com> <45DCB1BE.403@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:63143 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXBUXBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 18:01:21 -0500
Received: by nz-out-0506.google.com with SMTP id s1so2361921nze
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 15:01:21 -0800 (PST)
In-Reply-To: <45DCB1BE.403@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: John Scarpa <john@tlchosting.com>, dougg@torque.net, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

djwong@us.ibm.com wrote:
> John Scarpa wrote:
>   
>> First a very big thanks to all of u! I have been suffering a serious
>> lack of sleep problem lately..  i should have noticed that by whom has
>> been submitting the past 500 fixes and updates!
>>
>> Quick question, is the driver still consider experimental??
>>     
>
> Very much so.  The SAS bits are fairly stable nowadays, but the rest is
> still YMWV. :)
>
>   
>> the guys i
>> work with say it doesn't support sata drives and it's still experimental
>>     
>
> SATA support is under development.  Patches exist in the git tree here:
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=summary
>
>   
>> so don't use it.  And i can't find anything on the state of this driver.
>>
>> PS.  I should have said i dropped that aic94xx-seq.fw in
>> /lib,/lib/firmware,/lib64,/lib64/firmware  (still have yet to get this
>> sucker to work)
>>     
>
> Yes, you need a udev that's new enough to know how to handle the
> firmware loading interface.  Typically, udev will load firmware from
> /lib/firmware, though I suppose that depends on the distribution.  Not
> sure if RH/Fedora support fw loading, newer Ubuntu-E and SuSE do...
>
> --D
>   
Fedora Core 6 does. I just had to drop the firmware into /lib/firmware 
to get it loaded correctly. Unfortunately the drivers in the Fedora 
kernels do not have the SATA support merged into them. I looked at the 
aic94xx-sas-2.6.git tree, but it looks like things have been swapped 
around between scsi and libata since 2.6.19.1 (the latest fc6 update 
kernel). If anyone has versions of the SATA support patches that apply 
on top of a Fedora kernel, could you please direct me to them?

Aravind.

> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


From: Mark Rustad <mrustad@mac.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 2 Mar 2006 20:16:20 -0600
Message-ID: <A421A6E6-A405-4DEC-847D-C5F33AA0718F@mac.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com> <20060302231323.GA12869@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.mac.com ([17.250.248.88]:51912 "EHLO smtpout.mac.com")
	by vger.kernel.org with ESMTP id S1752146AbWCCCUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 21:20:43 -0500
In-Reply-To: <20060302231323.GA12869@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Mar 2, 2006, at 5:13 PM, Mike Anderson wrote:

> James Bottomley <James.Bottomley@SteelEye.com> wrote:
>> This fairly minimal patch correctly attaches the aic94xx driver to  
>> the
>> SAS transport class (The driver is available from
>>
>> www.kernel.org/git/jgarzik/sas-2.6
>>
>> ).  Unfortunately, the driver itself still has the following critical
>> issues
>>
>> 1. Discovery order is non-deterministic (it starts one thread per  
>> port,
>> so the threads race for discovery)
>
> The issue also results in the device discovery not completing by  
> the time
> the module load completes resulting in the initrd not finding the boot
> disk
> http://bugzilla.kernel.org/show_bug.cgi?id=6045
>
> I agree that we need a solution for this. Should the solution be in  
> the
> LLDDs.I thought previous comments was that we wanted this fixed  
> outside
> the kernel in user space. Though I have not seen any enabled  
> support in
> initrds or support in the initrd bins.
>
> This appears to not only be an issue with aic94xx as it appears  
> this could
> happen with some of the fc transport LLDDs.

It also is a problem for usb-storage devices. I have to use a kernel  
parameter of "boot_delay=7" for my USB root device to be available.  
Fine for my system, but ugly in general.

-- 
Mark Rustad, MRustad@mac.com


From: Kevin K <k_krieser@sbcglobal.net>
Subject: Re: SCSI selection issue with aic7xxx_old driver
Date: Fri, 31 Mar 2006 19:36:44 -0600
Message-ID: <8E071655-7B5C-4F20-BDBB-49F37B03F171@sbcglobal.net>
References: <F6783F90-89ED-4D3C-9D42-8F97D91907E0@sbcglobal.net> <1143802756.3053.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0 (Apple Message framework v746.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:61784 "HELO
	smtp111.sbc.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751471AbWDABgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 20:36:48 -0500
In-Reply-To: <1143802756.3053.0.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org


On Mar 31, 2006, at 4:59 AM, Arjan van de Ven wrote:

> On Wed, 2006-03-29 at 11:51 -0600, Kevin K wrote:
>> I'm in the process up converting from RHEL 2.1 to RHEL 4, and have
>> encountered an issue with the aic7xxx_old driver (5.2.6, as provided
>> with the RH 2.4.9-34 kernel, and with 2.6.15.5 kernel).
>>
>>   The SCSI card is an Adaptec 2940U card.
>>
>>   Namely, an old SCSI device isn't being seen very often.  Maybe 1 in
>> 10 times loading the module.  Under the 2.4.18 kernel, it was always
>> seen using this driver except in the case of hardware/cabling issues.
>>
>>   With the same hardware and OS, but using the new driver (aic7xxx),
>> the hardware is consistently seen.
>
> well... sounds you have a solution right there... ;)
> the _old driver isn't really actively maintained anymore since... a  
> long
> time. At least the "new" one has been getting maintenance
>

Unfortunately, the main reason we've stayed with the old driver was  
that an application we inherited didn't work properly at a low level  
with the "new" driver, even on versions of the Linux Kernel, such as  
2.4.18, that the application worked with the "old" driver.

Now, with attempting to port it to a more modern Linux kernel and  
distribution, we appear to have a choice of finally getting it to  
work with the new driver, since the old driver isn't seeing the  
hardware properly.

We were just hoping to eliminate one stumbling block by remaining  
with the old driver.  It isn't like we are using modern hardware.   
The 2940 is quite old now, and the SCSI device is older still ;)

Thanks,

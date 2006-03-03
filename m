From: Mark Rustad <mrustad@mac.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 10:51:25 -0600
Message-ID: <EDB6EB8C-7109-46E1-898E-7D8EAB0D4260@mac.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com> <20060302231323.GA12869@us.ibm.com> <A421A6E6-A405-4DEC-847D-C5F33AA0718F@mac.com> <20060302200419.b37c2fd9.rdunlap@xenotime.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.mac.com ([17.250.248.85]:49858 "EHLO smtpout.mac.com")
	by vger.kernel.org with ESMTP id S1751487AbWCCQvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 11:51:46 -0500
In-Reply-To: <20060302200419.b37c2fd9.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: andmike@us.ibm.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, Robert_Tarte@adaptec.com

On Mar 2, 2006, at 10:04 PM, Randy.Dunlap wrote:

>> It also is a problem for usb-storage devices. I have to use a kernel
>> parameter of "boot_delay=7" for my USB root device to be available.
>> Fine for my system, but ugly in general.
>
> where is that kernel boot option, pray tell?
> I don't seem to be able to find it.

That is because I got it wrong (I should have looked at my menu.lst).  
It is actually "rootdelay=7" in my case. It is documented in  
Documentation/kernel-parameters.txt. Sorry for the mistaken  
information before.

-- 
Mark Rustad, MRustad@mac.com


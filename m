From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Mon, 12 Jun 2006 12:44:30 -0500
Message-ID: <448DA7FE.3010901@cs.wisc.edu>
References: <8889.1149988615@bebe.enoyolf.org> <448DA7AD.4010203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6034 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750780AbWFLRr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 13:47:58 -0400
In-Reply-To: <448DA7AD.4010203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@bebe.enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org, dwm@austin.ibm.com

Mike Christie wrote:
> Doug Maxey wrote:
>> Subject: [RFC] qla4xxx: TODO for re-submission
>>
>> Howdy!
>>
>> The qla4xxx driver for the QLogic ISP4XXX chipset will be getting a
>> little janitorial love along the lines of:
>>
>> A) a rework of the 2006-06-06 Qlogic submitted qla4xxx code to get the
>>    driver to be in line with the kernel coding style.
>> B) being made more compliant with the scsi_mid_low_api.txt.  Being
>>    compiled for M$ does not count as an alternative OS. :)  In
>>    particular, move all the code to single .c file.  If and when
>>    another chipset comes along that can utilize some of the bits, look
>>    into splitting it back up.
>> C) removal of unreachable or unused code.
>> D) a rework of the function layout and size, including linewidth adjustments
>> E) fixups to printk formatting, and moving to dev_printk().  For the
>>    first pass, just remove the debug printk()'s
>>
>> This will not be a re-write of the driver per se, just a refactoring
>> going on in parallel to the work of the QLogic folks and mike, in an
>> effort to get this driver into mainline.
>>
>> The plan is to:
>> 1) submit the Documentation/LICENSE.qla4xxx.txt file and check
>>    the provenance with the original submitters..
>> 2) pull all the data structs into the file, swizzle the types to be
>>    kernel compliant.
>> 3) pull the core driver initialization (module_init(), pci init et al)
>>    into the file drivers/scsi/qla4xxx.c
>> 4) add the iscsi transport code.
>> 5) add the block layer code.
>> 6) add the device firmware access.
>> 7) add the hooks for the Kconfig and Makefile
>>
>> Does this appear to be a workable plan?  Should the struct cleanup
>> wait and come in on an as needed basis?
>>
> 
> I think I am fine with what I have already said needs to be done + all
> the cleanup issues where the coding style got mixed up during driver
> writer transitions.

The removing of the dead/unused code should of course be done too.

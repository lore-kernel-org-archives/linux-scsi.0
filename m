From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH 6/10][RFC] linux-iscsi driver
Date: Wed, 12 Jan 2005 15:22:20 -0800
Message-ID: <41E5B12C.2030802@us.ibm.com>
References: <41E30958.5060309@cs.wisc.edu>	 <1105569717.21043.3.camel@markh1.pdx.osdl.net>	 <41E5AB40.2050904@us.ibm.com> <1105570966.21043.6.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:18098 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261568AbVALXW1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 18:22:27 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0CNMMZ7330626
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:22:22 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0CNMM8P248334
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 16:22:22 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0CNML1E011196
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 16:22:22 -0700
In-Reply-To: <1105570966.21043.6.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Haverkamp wrote:
> On Wed, 2005-01-12 at 14:57 -0800, Mike Christie wrote:
> 
>>Mark Haverkamp wrote:
>>
>>>On Mon, 2005-01-10 at 15:01 -0800, Mike Christie wrote:
>>>
>>>
>>>>The attached patch implememts the IO functions for
>>>>the driver. They are built upon the network
>>>>subsystem's socket functions, so any ideas about
>>>>how to handle OOM situations when using that
>>>>layer would be greatly appreciated.
>>>
>>>
>>>I get:
>>>
>>>  BUILD   arch/i386/boot/bzImage
>>>Root device is (3, 3)
>>>Boot sector 512 bytes.
>>>Setup is 5215 bytes.
>>>System is 2530 kB
>>>Kernel: arch/i386/boot/bzImage is ready
>>>  Building modules, stage 2.
>>>  MODPOST
>>>*** Warning: "__scsi_print_sense" [drivers/scsi/iscsi-sfnet/iscsi_sfnet.ko] undefined!
>>>
>>>
>>>when building the iscsi module in the latest kernel BK view.
>>>
>>>
>>
>>just to make sure, when you open drivers/scsi/constants.c
>>you see
>>EXPORT_SYMBOL(__scsi_print_sense);
>>right?
> 
> 
> I don't see __scsi_print_sense in constants.c, just scsi_print_sense and
> it has a different arg list than your usage of __scsi_print_sense.
> 
  > Mark.
> 

In the newest constants.c in scsi-misc it looks like it is there
http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/anno/drivers/scsi/constants.c@1.22?nav=index.html|src/|src/drivers|src/drivers/scsi

Same for http://linux.bkbits.net:8080/linux-2.5
http://linux.bkbits.net:8080/linux-2.5/anno/drivers/scsi/constants.c@1.22?nav=index.html|src/|src/drivers|src/drivers/scsi



From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH 6/10][RFC] linux-iscsi driver
Date: Wed, 12 Jan 2005 14:57:04 -0800
Message-ID: <41E5AB40.2050904@us.ibm.com>
References: <41E30958.5060309@cs.wisc.edu> <1105569717.21043.3.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47085 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261548AbVALW5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 17:57:18 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0CMvBBW012579
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 17:57:11 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0CMv5HZ229548
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 17:57:05 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0CMv5u5026050
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 17:57:05 -0500
In-Reply-To: <1105569717.21043.3.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Haverkamp wrote:
> On Mon, 2005-01-10 at 15:01 -0800, Mike Christie wrote:
> 
>>The attached patch implememts the IO functions for
>>the driver. They are built upon the network
>>subsystem's socket functions, so any ideas about
>>how to handle OOM situations when using that
>>layer would be greatly appreciated.
> 
> 
> I get:
> 
>   BUILD   arch/i386/boot/bzImage
> Root device is (3, 3)
> Boot sector 512 bytes.
> Setup is 5215 bytes.
> System is 2530 kB
> Kernel: arch/i386/boot/bzImage is ready
>   Building modules, stage 2.
>   MODPOST
> *** Warning: "__scsi_print_sense" [drivers/scsi/iscsi-sfnet/iscsi_sfnet.ko] undefined!
> 
> 
> when building the iscsi module in the latest kernel BK view.
> 
> 

just to make sure, when you open drivers/scsi/constants.c
you see
EXPORT_SYMBOL(__scsi_print_sense);
right?

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] add iSCSI session creation sysfs attributes
Date: Tue, 25 Jan 2005 12:37:22 -0800
Message-ID: <41F6AE02.3040400@cs.wisc.edu>
References: <41F4D072.5040800@cs.wisc.edu> <1106580841.5513.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:21668 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262119AbVAYUhf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 15:37:35 -0500
In-Reply-To: <1106580841.5513.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2005-01-24 at 02:39 -0800, Mike Christie wrote:
> 
>>The attached patch built against scsi-misc-2.6 moves the
>>target iSCSI attributes to a new structure representing
>>a iSCSI session. The reason for doing this is to
>>create a interface that allows the Sourceforge iSCSI driver
>>to create and setup a session through sysfs (no more
>>IOCTL at all in our driver), display session info, and at the same
>>time share code and use the same interface HW iSCSI drivers would
>>use.
> 
> 
> This no longer applies to the iscsi transport class because I converted
> it over to the generic framework.  Could you look at the code in
> 
> bk://linux-scsi.bkbits.net/scsi-rc-fixes-2.6 (or the patch on
> www.parisc-linux.org/~jejb/scsi_diffs)
> 
> and reroll your patch against that?

Will do. One question though. If a function like
transport_add_device or transport_setup_device fails,
how does the caller detect this?

> 
> Thanks,
> 
> James
> 
> 


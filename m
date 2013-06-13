From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 10/10] [RFC] SCSI: esas2r: Add Makefile, Kconfig, and
 MAINTAINERS files
Date: Thu, 13 Jun 2013 14:57:39 -0400
Message-ID: <51BA1623.6000000@attotech.com>
References: <51B9EA2E.5090501@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:15782 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757377Ab3FMS5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jun 2013 14:57:41 -0400
In-Reply-To: <51B9EA2E.5090501@profitbricks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: jseba@attotech.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org

On 06/13/2013 11:50 AM, Jack Wang wrote:
>>   S:     Supported
>> -F:     drivers/block/nvme*
>> +F:     drivers/block/nvme.c
>>   F:     include/linux/nvme.h
>
> I don't think you want to change this, it seems you are not generate
> your patch set against scsi misc branch?
>
> Regards,
> Jack
>

I generated the patch from the kernel tree instead of the misc branch of 
the scsi tree.  I'll fix that when I spin the next patch.

Brad

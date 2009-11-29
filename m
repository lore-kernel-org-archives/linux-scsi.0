From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: linux-next: manual merge of the osd tree with the scsi tree
Date: Sun, 29 Nov 2009 16:23:05 +0200
Message-ID: <4B1283C9.1030002@panasas.com>
References: <20091127143229.108298c6.sfr@canb.auug.org.au>	 <4B123A82.10104@panasas.com>  <4B127202.1010900@panasas.com> <1259502399.2827.14.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:2955 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbZK2OXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 09:23:02 -0500
In-Reply-To: <1259502399.2827.14.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open-osd <osd-dev@open-osd.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On 11/29/2009 03:46 PM, James Bottomley wrote:
>>
>> Should I repost the correct two patches (my preference)? should I send in a fix to
>> current scsi-misc tree? or should I send two SQUASH-ME patches to the two bad commits
>> in your tree?
>>
>> How do you want to proceed?
> 
> Send me the replacement patch (and tell me which commit id in my tree
> it's replacing).
> 

Thank you James.

I'm posting two patches as reply to this mail.

[PATCH 1/2] osduld: Use device->release instead of internal kref
which replaces:
f89b9ee [SCSI] osduld: Use device->release instead of internal kref

and

[PATCH 2/2] libosd: osd_dev_info: Unique Identification of an OSD device
which replaces:
3b616d4 [SCSI] libosd: osd_dev_info: Unique Identification of an OSD device


> Thanks,
> 
> James
> 
> 

Boaz

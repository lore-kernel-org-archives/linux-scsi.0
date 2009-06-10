From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/2 version 4] osdblk: a Linux block device for OSD objects
Date: Wed, 10 Jun 2009 16:33:14 +0300
Message-ID: <4A2FB61A.6010102@panasas.com>
References: <4A155FF6.3060005@panasas.com> <4A15D883.1060104@garzik.org> <4A1B9DA4.2080304@panasas.com> <4A1F10A4.30601@garzik.org> <4A2252D4.3080301@panasas.com> <4A2FACA2.1070405@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:15276
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751868AbZFJNdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 09:33:17 -0400
In-Reply-To: <4A2FACA2.1070405@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Jens Axboe <jens.axboe@oracle.com>

On 06/10/2009 03:52 PM, Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> OK I will release something Quick-And-Dirty end of this week.
>> It should do those three tasks osdblk needs:
>> Create Resize Delete object@partition@device
> 
> That works, thanks!  Honestly, only create and delete are really 
> _needed_ IMO.
> 
> 	Jeff
> 
> 

I'll be on this ASAP. I have a working draft just needs a cleanup and
submission, which is queued behind all these other pressing things.

Boaz

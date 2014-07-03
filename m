From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 08/14] block: Add a disk flag to block integrity profile
Date: Thu, 03 Jul 2014 12:58:17 +0300
Message-ID: <53B52939.5010900@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>	<1401334128-15499-9-git-send-email-martin.petersen@oracle.com>	<20140611164858.GC9511@infradead.org>	<yq1ha3qrk1x.fsf@sermon.lab.mkp.net>	<20140625102441.GA24735@infradead.org> <yq1d2dxfbup.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35446 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924AbaGCJ60 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 05:58:26 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1904048wib.13
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 02:58:21 -0700 (PDT)
In-Reply-To: <yq1d2dxfbup.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 6/25/2014 2:49 PM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> Christoph> On Wed, Jun 11, 2014 at 09:30:34PM -0400, Martin K. Petersen wrote:
>>> /sys/block/foo/integrity/disk_is_formatted_with_pi
>>> /sys/block/foo/integrity/disk_is_integrity_capable
>>> /sys/block/foo/integrity/disk_supports_storing_pi
>>>
>>> Or would you prefer something other than disk? target?
>>> storage_device?
> Christoph> I'd defintively prefer the target_ prefix and one of the
> Christoph> descriptive suffixes.
>
> OK, will tweak.
>

But this entry doesn't refer to a target, it refers to a backend device.
IMO disk_ or device_ or storage_device prefixes would be better...

Sagi.

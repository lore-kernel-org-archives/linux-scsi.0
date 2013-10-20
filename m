From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Sun, 20 Oct 2013 12:20:49 -0400
Message-ID: <526402E1.5060007@interlog.com>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com> <525BC836.2030306@suse.de> <20131014152950.GA6625@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49838 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3JTQU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Oct 2013 12:20:56 -0400
In-Reply-To: <20131014152950.GA6625@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: "Wangshen (C)" <peter.w@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Jinbo (Justin)" <jinbo@huawei.com>

On 13-10-14 11:29 AM, Christoph Hellwig wrote:
> On Mon, Oct 14, 2013 at 12:32:22PM +0200, Hannes Reinecke wrote:
>> However, there are two other patchsets pending (EH Deadline and
>> asynchronous command aborts), both of which have been tested
>> thoroughly _and_ have acked-by from various other parties.
>> None of these patchset had received any feedback from James
>> Bottomley, let alone any indication if or when they'll be merged.
>>
>> So I stopped sending further patchsets, sensing some communication
>> breakdown on the line.
>
> Maybe we'll need to start a common scsi staging tree for all patches
> that have gotten a wide amount of reviews and are interesting to many
> parties.  Thay way we have one common set of patches for the
> distributions to pull from, and a tree to develop against where
> dependencies between the patchsets exist.

Sounds like a good idea. Like Hannes I have several patches
that haven't been rejected but seem to have been lost in
the process:
   - expand the SG_SCSI_RESET ioctl() to include non reset
     escalating variants
   - permit the sg driver to accept SCSI cdbs greater than
     16 bytes long (bsg already can)

Also I have done some work in sg3_utils to support 64 bit
LUNs in Linux. That work assumes the solution proposed by Hannes.

Doug Gilbert


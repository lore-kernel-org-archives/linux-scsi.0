From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Wed, 13 Oct 2004 19:39:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416DBC96.2090602@pobox.com>
References: <4161A06D.8010601@rtr.ca> <4165B233.9080405@rtr.ca> <416D8A4E.5030106@pobox.com> <416DA951.2090104@rtr.ca> <416DAF1A.2040204@pobox.com> <416DB912.7040805@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:40398 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269937AbUJMXjP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 19:39:15 -0400
In-Reply-To: <416DB912.7040805@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
> 
>> Fine with me but you'll need more than just the identify data, if you 
>> wanna do stuff like support MODE SELECT/SENSE.
> 
> 
> QStor has no need for MODE_SELECT, and the current implementation
> of MODE_SENSE in libata-scsi appears to use only the IDENTIFY data.
> 
> The READ_CAPACITY emulation in libata-scsi currently uses dev->n_sectors,
> but that could be changed to recalculate it from the IDENTIFY words.
> 
> So.. okay in concept?

Seems sane, send a patch.

Typically we aren't in the business of pre-approving patches, much to 
ESR's chagrin :)

	Jeff



From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2] Split SCSI header files
Date: Tue, 7 Apr 2015 11:11:21 +0200
Message-ID: <55239F39.4050605@sandisk.com>
References: <55217B00.6030706@sandisk.com> <20150406150842.GA23569@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:24570
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410AbbDGJL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 05:11:28 -0400
In-Reply-To: <20150406150842.GA23569@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/06/15 17:08, Christoph Hellwig wrote:
> On Sun, Apr 05, 2015 at 08:12:16PM +0200, Bart Van Assche wrote:
>> Move the
>> functions that are used by both subsystems into <scsi/scsi_lib.h>.
>> Rename drivers/scsi/scsi_lib.c into scsi_ini_lib.c. This change
>> will allow to modify the SCSI target code such that the initiator
>> SCSI header files are no longer included. Note: the SCSI target
>> driver patch is available for review at
>
> I don't really like renaming the file that has most of the initiator side
> SCSI code that way.  If we really have to rename it in some way I'd suggest
> just merging it into scsi.c as we call forth and back between the two all
> the time.
>
> Maybe we can use scsi_common.c/h/.ko to avoid these moves, although I'd
> prefer to just duplicate this tiny amount of code.

Hello Christoph,

Sorry but duplicating code is not really something that makes me 
enthusiast ... But I will address all your other comments, including 
using the names scsi_common.c/.h.

Bart.

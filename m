From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v4 3/5] scsi: Move sense handling routines to scsi_common
Date: Wed, 8 Jul 2015 18:23:29 +0300
Message-ID: <559D4071.8010501@dev.mellanox.co.il>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
 <1436367534-15995-4-git-send-email-sagig@mellanox.com>
 <559D3C5C.4020903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35074 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbbGHPXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 11:23:18 -0400
Received: by wgjx7 with SMTP id x7so198899628wgj.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 08:23:17 -0700 (PDT)
In-Reply-To: <559D3C5C.4020903@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 7/8/2015 6:06 PM, Hannes Reinecke wrote:

> We're adding extra fields here, so we need to make sure to not
> overflow the buffer. You probably have to pass in the buffersize
> to avoid an overflow ...
> Yeah, I know, it's theoretical at the moment.
> But there's nothing which prevents anyone to add other fields to it,
> so this field might be the one causing the overflow.

Since this patch is simply a movement of functions I don't think I
should change any functionality here. Would it be acceptable to fix
this in an incremental patch?

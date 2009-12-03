From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 5/5] libata: Clarify ata_set_lba_range_entries function
Date: Thu, 03 Dec 2009 18:02:17 -0500
Message-ID: <4B184379.6000702@pobox.com>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com> <1259254843-8326-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:53131 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZLCXCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 18:02:15 -0500
In-Reply-To: <1259254843-8326-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 11/26/2009 12:00 PM, Martin K. Petersen wrote:
> ata_set_lba_range_entries used the variable max for two different things
> which was confusing.  Make the function take a buffer size in bytes as
> argument and return the used buffer size upon completion.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
> ---
>   drivers/ata/libata-scsi.c |    2 +-
>   include/linux/ata.h       |   20 ++++++++++----------
>   2 files changed, 11 insertions(+), 11 deletions(-)

applied



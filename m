From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: remove the disable_blk_mq host flag
Date: Wed, 13 Jul 2016 17:40:59 +0700
Message-ID: <09652818-4cd2-9ea1-46c9-29d34db1d473@sandisk.com>
References: <1468383545-28503-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0048.outbound.protection.outlook.com ([104.47.38.48]:42790
	"EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941AbcGMLOy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2016 07:14:54 -0400
In-Reply-To: <1468383545-28503-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/13/2016 11:19 AM, Christoph Hellwig wrote:
> We've had scsi-mq for 2.5 years now, so we can remove the unused flag
> to disable the code on a per-host basis that was put in for unexpected
> emergencies during bringup.

Reviewed-by: bart.vanassche@sandisk.com

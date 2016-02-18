From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 11/23] scsi_dh_alua: move optimize_stpg evaluation
Date: Thu, 18 Feb 2016 11:49:37 -0800
Message-ID: <56C62051.4090705@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:30839
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947194AbcBRTtm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 14:49:42 -0500
In-Reply-To: <1455524690-121073-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> When the optimize_stpg module option is set we should just set it
> once during port_group allocation. Doing so allows us to override
> it later with device specific settings.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

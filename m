From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 15/23] scsi_dh_alua: Add new blacklist flag
 'BLIST_SYNC_ALUA'
Date: Thu, 18 Feb 2016 13:14:06 -0800
Message-ID: <56C6341E.1090408@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:3341
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947843AbcBRVOM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:14:12 -0500
In-Reply-To: <1455524690-121073-16-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Add a new blacklist flag BLIST_SYNC_ALUA to instruct the
> alua device handler to use synchronous command submission
> for ALUA commands.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi_dh_alua: do not fail for unknown VPD identification
Date: Tue, 10 May 2016 13:12:16 -0700
Message-ID: <573240A0.6070400@sandisk.com>
References: <1462523675-63172-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:54804
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbcEJU2P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2016 16:28:15 -0400
In-Reply-To: <1462523675-63172-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 05/06/2016 01:34 AM, Hannes Reinecke wrote:
> Not every device will return a useable VPD identification, but
> still might support ALUA. Rather then disable ALUA support we
> should be allowing the device identification to be empty and
> attach individual ALUA device handler to each devices.
>
> Reported-by: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

If you have to repost this please fix the spelling of "identifcation". 
Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

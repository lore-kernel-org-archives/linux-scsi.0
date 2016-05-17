From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] sd: get disk reference in sd_check_events()
Date: Tue, 17 May 2016 10:51:18 -0700
Message-ID: <573B5A16.2050206@sandisk.com>
References: <1461650818-107190-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0081.outbound.protection.outlook.com ([207.46.100.81]:33632
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbcEQRvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2016 13:51:23 -0400
In-Reply-To: <1461650818-107190-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 04/25/2016 11:06 PM, Hannes Reinecke wrote:
> sd_check_events() is called asynchronously, and might race
> with device removal. So always take a disk reference when
> processing the event to avoid the device being removed while
> the event is processed.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>


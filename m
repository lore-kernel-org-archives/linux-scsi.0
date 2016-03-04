From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv2 6/6] scsi_sysfs: call 'device_add' after attaching
 device handler
Date: Fri, 4 Mar 2016 09:34:54 -0800
Message-ID: <56D9C73E.7020703@sandisk.com>
References: <1456988052-78791-1-git-send-email-hare@suse.de>
 <1456988052-78791-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:27678
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759535AbcCDRuA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2016 12:50:00 -0500
In-Reply-To: <1456988052-78791-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/02/2016 10:54 PM, Hannes Reinecke wrote:
> 'device_add' will be evaluating the 'is_visible' callback
> when creating the sysfs attributes. As by this time the
> device handler has not been attached the 'access_state'
> attribute will never be visible.
>
> This patch moves the code around so that the device handler
> is present by the time 'is_visible' is evaluated to
> correctly display the 'access_state' attribute.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>

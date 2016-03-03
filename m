From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv2 1/6] scsi: Add 'access_state' and 'preferred_path'
 attribute
Date: Thu, 3 Mar 2016 14:45:10 -0800
Message-ID: <56D8BE76.1090000@sandisk.com>
References: <1456988052-78791-1-git-send-email-hare@suse.de>
 <1456988052-78791-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0078.outbound.protection.outlook.com ([207.46.100.78]:63889
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757012AbcCCWpR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2016 17:45:17 -0500
In-Reply-To: <1456988052-78791-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/02/2016 10:54 PM, Hannes Reinecke wrote:
> Add an 'access_state' field to struct scsi_device
> and display them in sysfs as 'access_state' and
> 'preferred_path' attribute.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>

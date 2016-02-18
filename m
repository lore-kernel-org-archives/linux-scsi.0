From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 19/23] scsi_dh: add 'rescan' callback
Date: Thu, 18 Feb 2016 13:49:54 -0800
Message-ID: <56C63C82.50005@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:27232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753790AbcBRVt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:49:58 -0500
In-Reply-To: <1455524690-121073-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> If a device needs to be rescanned the device_handler might need
> to be rechecked, too.
> So add a 'rescan' callback to the device handler and call it
> upon scsi_rescan_device(). The rescan callback will be invoked
> from the Unit Attention handling of ASC/ASCQ 3F 03
> (INQUIRY DATA HAS CHANGED).

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

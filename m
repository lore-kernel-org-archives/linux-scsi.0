From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 20/23] scsi: Add 'access_state' attribute
Date: Thu, 18 Feb 2016 13:55:04 -0800
Message-ID: <56C63DB8.6020306@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:55328
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1425084AbcBRV4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:56:11 -0500
In-Reply-To: <1455524690-121073-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Add an 'access_state' attribute to struct scsi_device to
> display the asymmetric LUN access state.

Do we really need to add this attribute to SCSI devices that do not 
support ALUA, e.g. ATA devices ? From a system on which this patch 
series has been installed:

[root ~]# lsscsi | grep 0:0:0:0
[0:0:0:0] disk ATA ST1000NM0033-9ZM GA67 /dev/sda
[root ~]# cat /sys/class/scsi_device/0:0:0:0/device/access_state
active/optimized

Bart.

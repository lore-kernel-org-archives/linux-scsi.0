From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 12/23] scsi_dh_alua: remove 'rel_port' from alua_dh_data
 structure
Date: Thu, 18 Feb 2016 11:50:02 -0800
Message-ID: <56C6206A.6060409@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0061.outbound.protection.outlook.com ([65.55.169.61]:51744
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423242AbcBRTvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 14:51:02 -0500
In-Reply-To: <1455524690-121073-13-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> The 'relative port' field is not used, and might get stale when
> the port group changes. So remove the field altogether.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

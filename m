From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 02/23] scsi_dh_alua: separate out alua_stpg()
Date: Thu, 18 Feb 2016 10:22:21 -0800
Message-ID: <56C60BDD.4040603@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0075.outbound.protection.outlook.com ([207.46.100.75]:3552
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423389AbcBRSWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 13:22:25 -0500
In-Reply-To: <1455524690-121073-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Separate out SET TARGET PORT GROUP functionality into a separate
> function alua_stpg().

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

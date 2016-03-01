From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/6] scsi_dh_alua: use common definitions for ALUA state
Date: Tue, 1 Mar 2016 10:47:39 -0800
Message-ID: <56D5E3CB.4060107@sandisk.com>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
 <1456808143-88932-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0075.outbound.protection.outlook.com ([207.46.100.75]:39754
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751923AbcCASr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 13:47:58 -0500
In-Reply-To: <1456808143-88932-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/29/2016 08:55 PM, Hannes Reinecke wrote:
> scsi_proto.h now contains definitions for the ALUA state,
> so we don't have to carry them in the device handler.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>

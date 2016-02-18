From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 22/23] scsi_dh_alua: update 'access_state' field
Date: Thu, 18 Feb 2016 14:12:54 -0800
Message-ID: <56C641E6.2090600@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:45616
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1424744AbcBRWNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 17:13:30 -0500
In-Reply-To: <1455524690-121073-23-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Track attached SCSI devices and update the 'access_state' field
> whenever an ALUA state change has been detected.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

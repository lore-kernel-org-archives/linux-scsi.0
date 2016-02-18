From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 04/23] scsi_dh_alua: call alua_rtpg() if stpg fails
Date: Thu, 18 Feb 2016 10:24:03 -0800
Message-ID: <56C60C43.40005@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:25376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423389AbcBRSYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 13:24:54 -0500
In-Reply-To: <1455524690-121073-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> If the call to SET TARGET PORT GROUPS fails we have no idea what
> state the array is left in, so we need to issue a call to
> REPORT TARGET PORT GROUPS in these cases.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

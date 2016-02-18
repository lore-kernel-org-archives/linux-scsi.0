From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 18/23] scsi_dh_alua: Send TEST UNIT READY to poll for
 transitioning
Date: Thu, 18 Feb 2016 13:48:42 -0800
Message-ID: <56C63C3A.6030000@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bn0100.outbound.protection.outlook.com ([157.56.110.100]:49108
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753790AbcBRVtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 16:49:10 -0500
In-Reply-To: <1455524690-121073-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
> as the array has to gather information about all ports.
> So instead of using RTPG to poll for a status update when a port
> is in transitioning we should be sending a TEST UNIT READY, and
> wait for the sense code to report success.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

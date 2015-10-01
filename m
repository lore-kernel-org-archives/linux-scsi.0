From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 07/36] scsi_dh_alua: use standard logging functions
Date: Thu, 1 Oct 2015 16:50:30 -0700
Message-ID: <560DC6C6.6000102@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0067.outbound.protection.outlook.com ([157.56.111.67]:46048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301AbbJBAE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 20:04:57 -0400
In-Reply-To: <1443523658-87622-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> -		if (!err) {
> -			err = SCSI_DH_IO;
> -			goto done;
> -		}

The assignment to 'err' was removed in patch 06/36 so this part should 
be moved to patch 06/36. Otherwise this patch looks fine to me.

Bart.


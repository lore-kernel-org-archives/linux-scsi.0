From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 06/36] scsi_dh_alua: sanitze sense code handling
Date: Thu, 1 Oct 2015 16:39:41 -0700
Message-ID: <560DC43D.7020708@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0054.outbound.protection.outlook.com ([65.55.169.54]:45760
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750879AbbJAXjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 19:39:48 -0400
In-Reply-To: <1443523658-87622-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> The only check for a valid sense code is calling scsi_normalize_sense()
> and check the return value. So drop the pointless checks and rely on
> scsi_normalize_sense() to figure out if the sense code is valid.
> With that we can also remove the 'senselen' field.
>
> Signed-off-by: Hannes Reinecke<hare@suse.de>

Reviewed-by: Bart Van Assche <bvanassche@sandisk.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 07/23] scsi_dh_alua: Use separate alua_port_group
 structure
Date: Thu, 18 Feb 2016 11:41:47 -0800
Message-ID: <56C61E7B.9050509@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0088.outbound.protection.outlook.com ([207.46.100.88]:39747
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946668AbcBRTlv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 14:41:51 -0500
In-Reply-To: <1455524690-121073-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
>   	if (optimize)
> -		h->flags |= ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ALUA_OPTIMIZE_STPG;
>   	else
> -		h->flags &= ~ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ~ALUA_OPTIMIZE_STPG;

The above looks weird to me. Why has "&=" been changed into "|=" ?

Bart.

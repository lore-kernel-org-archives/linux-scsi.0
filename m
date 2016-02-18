From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 09/23] scsi_dh_alua: simplify alua_initialize()
Date: Thu, 18 Feb 2016 11:48:18 -0800
Message-ID: <56C62002.7070700@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:13290
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946920AbcBRTsa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 14:48:30 -0500
In-Reply-To: <1455524690-121073-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> Rework alua_check_vpd() to use scsi_vpd_get_tpg()
> and move the port group selection into the function, too.
> With that we can simplify alua_initialize() to just
> call alua_check_tpgs() and alua_check_vpd();

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

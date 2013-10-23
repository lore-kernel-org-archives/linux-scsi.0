From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI: Disable WRITE SAME for RAID and virtual host
 adapter drivers
Date: Wed, 23 Oct 2013 09:11:37 -0700
Message-ID: <20131023161137.GA31895@infradead.org>
References: <yq1eh7cffmj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3JWQLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 12:11:37 -0400
Content-Disposition: inline
In-Reply-To: <yq1eh7cffmj.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

> @@ -3625,6 +3625,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
>  		shost->max_lun = 1;
>  		shost->max_channel = 1;
>  		shost->max_cmd_len = 16;
> +		shost->no_write_same = 1;

Unless I miss something this will disable TRIM support in libata
entirely.


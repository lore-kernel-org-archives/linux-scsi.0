From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi_dh_emc: switch to scsi_execute_req_flags()
Date: Wed, 2 Nov 2016 16:08:32 +0100
Message-ID: <20161102150832.GB14320@lst.de>
References: <1478036978-30583-1-git-send-email-hare@suse.de> <1478036978-30583-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33075 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753223AbcKBPIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Nov 2016 11:08:35 -0400
Content-Disposition: inline
In-Reply-To: <1478036978-30583-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Nov 01, 2016 at 10:49:37PM +0100, Hannes Reinecke wrote:
> Switch to scsi_execute_req_flags() instead of
> using the block interface directly. This will set

... and scsi_get_vpd_page()

> +	if ((sshdr->sense_key == 0x05) && (sshdr->asc == 0x04) &&
> +	    (sshdr->ascq == 0x00)) {

> +	} else if ((sshdr->sense_key == 0x02) && (sshdr->asc == 0x04) &&
> +		   (sshdr->ascq == 0x03)) {

No need for the inner braces.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

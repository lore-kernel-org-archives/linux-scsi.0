From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] scsi_dh_hp_sw: switch to scsi_execute_req_flags()
Date: Wed, 2 Nov 2016 16:10:14 +0100
Message-ID: <20161102151014.GC14320@lst.de>
References: <1478036978-30583-1-git-send-email-hare@suse.de> <1478036978-30583-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33084 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752592AbcKBPKQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Nov 2016 11:10:16 -0400
Content-Disposition: inline
In-Reply-To: <1478036978-30583-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> +		switch (sshdr.sense_key) {
> +		case NOT_READY:
> +			if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {

No need for the inner braces.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

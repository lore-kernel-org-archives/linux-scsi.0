From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN
 scanning
Date: Fri, 5 Dec 2014 00:43:15 +0100
Message-ID: <20141205004315.00001523@localhost>
References: <1417711162-102950-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51910 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119AbaLDXon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 18:44:43 -0500
In-Reply-To: <1417711162-102950-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Martthias Roessler <Matthias.Roessler@ts.fujitsu.com>, Sebastian Herbszt <herbszt@gmx.de>

Hannes Reinecke wrote:
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 49014a1..4f446e3 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -166,6 +166,7 @@ static struct {
>  	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
>  	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
>  	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"FUJITSU", "ETERNUS_DX", "*", BLIST_TEST_LUN0 },
>  	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
>  	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
>  	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},

Does this apply to all ETERNUS DX models and generations?

Sebastian

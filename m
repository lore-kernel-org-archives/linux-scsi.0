From: Matthias Roessler <Matthias.Roessler@ts.fujitsu.com>
Subject: Re: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN
 scanning
Date: Mon, 8 Dec 2014 18:11:54 +0100
Message-ID: <20141208171154.GB32116@ts.fujitsu.com>
References: <1417711162-102950-1-git-send-email-hare@suse.de>
 <20141205004315.00001523@localhost>
 <5481FA9D.6040305@suse.de>
Reply-To: Matthias.Roessler@ts.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:13853 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaLHRM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2014 12:12:29 -0500
Content-Disposition: inline
In-Reply-To: <5481FA9D.6040305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Sebastian Herbszt <herbszt@gmx.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> 
> On 12/05/2014 12:43 AM, Sebastian Herbszt wrote:
> > Hannes Reinecke wrote:
> >> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> >> index 49014a1..4f446e3 100644
> >> --- a/drivers/scsi/scsi_devinfo.c
> >> +++ b/drivers/scsi/scsi_devinfo.c
> >> @@ -166,6 +166,7 @@ static struct {
> >>  	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
> >>  	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
> >>  	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> >> +	{"FUJITSU", "ETERNUS_DX", "*", BLIST_TEST_LUN0 },
> >>  	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
> >>  	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
> >>  	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
> > 
> > Does this apply to all ETERNUS DX models and generations?
> > 
> So I've been given to understand. Matthias Roessler will have details.
> 

Yes,

Fujitu's main line for Enterprise-grade storage systems 
is named "ETERNUS DX" over the past years and this product line
is still valid. Despite of product names like  "ETERNUS DX90 S2" or
"ETERNUS DX600 S3", they answer the scsi inquiry always with
    Vendor identification:  FUJITSU 
    Product identification: ETERNUS_DX*
where '*' stands for one of [L, M, 400, ...]  depending on the
exact model variant.
There was an ETERNUS4000 raid system with the
Product identification:  E4000
but this product is not of relevance anymore.


Best regards
Matthias



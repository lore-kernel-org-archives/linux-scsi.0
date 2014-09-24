From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Wed, 24 Sep 2014 13:59:04 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9A0AF@G9W0745.americas.hpqcorp.net>
References: <5412EA9F.4060703@redhat.com> <54229D86.4050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:45085 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXOAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 10:00:08 -0400
In-Reply-To: <54229D86.4050205@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Scales, Webb" <webb.scales@hp.com>, "Handzik, Joe" <joseph.t.handzik@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>



> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Wednesday, September 24, 2014 5:32 AM
> To: 'linux-scsi@vger.kernel.org'
> Cc: Elliott, Robert (Server Storage); steve.cameron@hp.com; Christoph
> Hellwig; Handzik, Joe
> Subject: Re: [PATCH] hpsa: add missing pci_set_master in kdump path
> 
> Christoph,
> 
> this is a fix for 132aa220b45d60e9b20def1e9d8be9422eed9616 hpsa: refine
> the pci enable/disable handling
> which is in 'for-3.18'.
> If this patch will not be reviewed and added to 3.18 the aforementioned
> patch needs to be reverted.
> 
> Tomas

Sorry for the delay - that is fine to go in directly, or will be part
of a larger hpsa series if HP or PMC is able to post one for 3.18.

Bit of business turmoil here lately...

For the interim you can add:
Reviewed-by: Robert Elliott <elliott@hp.com>
Tested-by: Robert Elliott <elliott@hp.com>
Acked-by: Robert Elliott <elliott@hp.com>


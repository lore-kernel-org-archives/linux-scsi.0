From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: [2.4.21] Spurious ABORTs
Date: Tue, 27 Sep 2005 12:18:12 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD1DD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42178 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964943AbVI0QSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 12:18:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>
Cc: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>

Update to myself:

When I return SUCCESS to the spurious ABORTs, the systems keeps
running. I am getting aborts for commands that I completed as
early as 60+ seconds ago. Could somebody please tell me what in
SCSI layer can cause it to do this?

Thanks,
Sreenivas

>
>I am running rather heavy IO's on our MegaRAID controller on a 
>Red Hat 3.0 Gold (2.4.21-4.Elsmp) 32 kernel. After a while, I 
>notice that the OS sends the abort requests for commands that 
>the driver has completed a while ago! I am using the unused 
>struct scsi_cmnd->SCp fields to record the entry/exit 
>timestamps and also the status of each commands while it is 
>being processed.
>When I get the abort request, I am seeing that driver had 
>completed the command already.
>
>I know that this is not an appropriate list to ask RH specific 
>question. But I wasn't sure if it RH specific bug or if there 
>are any known situations where 2.4 based kernels would try to 
>_abort_ previously completed commands. I tried tracing the 
>SCSI mid-layer code and I quickly got lost.
>

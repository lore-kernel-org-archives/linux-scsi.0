From: Anton Blanchard <anton@samba.org>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 02:47:13 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314154713.GH19737@krispykreme>
References: <20040314082444.GA3416@linux.local.home> <1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de> <1079276396.2022.8.camel@mulgrave> <20040314151809.GG19737@krispykreme> <1079278279.2022.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:28128 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261474AbUCNPwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 10:52:00 -0500
Content-Disposition: inline
In-Reply-To: <1079278279.2022.34.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 
> If you think you don't know how many resource slots you'll need, that's
> in scsi_cmnd->request->nr_hw_segments (give or take, this is always
> guaranteed to be at or over the actual number dma_map_sg eventually
> returns).  So: fix the qlogic mapping routines.

Yes I agree the driver should be fixed. My question was more a response
to the Jens' query about why the SG limit was introduced.

Lets ignore the pci_map_sg problem and assume the qlogic driver did the 
right thing. Whats to stop the upper layers from continually trying to 
queue things when we run out of request slots? If its just sg_tablesize 
then we are stuck with the current compromise (ie set it to something
reasonably low).

Anton

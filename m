From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 14:43:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704925053@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56205 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266397AbUFUSoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:44:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

I would need to keep linux_compat.h for compatibility
between lk 2.6 kernels variants.

Example - I'm building SuSE 9.1 drivers for the 2.6.4-52 , this
kernel doesn't define scsi_device_online; coming later in the 2.6.6.
I suggest keeping compatibity in the headers as 
opposed to the .c files.

Eric


> I don't think we need to keep around linux_compat.h in the 
> 2.6 tree, just
> remove it completely in 2.6 and keep it around in 2.4.
> 

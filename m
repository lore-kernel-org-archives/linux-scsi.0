From: Jes Sorensen <jes@trained-monkey.org>
Subject: qla1280-3.25 test driver (guinea pig wanted! - beware)
Date: Wed, 21 Jan 2004 09:28:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16398.35971.992815.17326@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:27873 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S265436AbUAUO2V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 09:28:21 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, Christoph Hellwig <hch@lst.de>, jeremy@sgi.com

Hi,

I am working on an new version of the qla1280 driver which cleans up the
queue command operations significantly. However I currently only have
cards in 64 bit boxes so I am looking for someone with a 32 bit box to
play guinea pig.

If you're willing to give it a spin, then I'd love to here the
results. However beware this is a test driver so if it eats your drive
alive, I will take no responsibility (I have tested it here quite a lot
and at least for ia64 boxes it seems to survive).

The driver can be found at
http://www.trained-monkey.org/jes/linux/testing/qla-3.25-testing.tar.gz

Thanks,
Jes

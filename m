From: Jeff Garzik <jeff@garzik.org>
Subject: libata moved to drivers/ata
Date: Thu, 10 Aug 2006 07:58:08 -0400
Message-ID: <44DB1F50.5040302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58588 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1161139AbWHJL6L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 07:58:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I just moved all branches of libata-dev.git to drivers/ata.

Please test and make sure I didn't break anything.

In particular, the move highlighted where libata and ata-generic were 
incorrectly using drivers/scsi local headers.  That was fixed too.

	Jeff



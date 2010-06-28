From: Ramya Desai <ramya.desai@gmail.com>
Subject: How to increase Scatter-Gather data buffer size in SCSI layer
Date: Mon, 28 Jun 2010 21:47:04 +0530
Message-ID: <AANLkTillrKo-w3wMB-ynkkJRwJmicIfInRfl1PuVDurv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42269 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0F1QRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 12:17:06 -0400
Received: by gxk23 with SMTP id 23so165717gxk.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 09:17:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Dear Experts,

Is there anyway to increase Scatter-Gather data buffer size in SCSI
layer, as my lower drivers are able to handle SG buffer size more than
4096 bytes. I am always getting 4096 as my SG data transfer buffer
size.

The Kernel version I am using is 2.6.34.

Thanks in advance,
Regards,
RD

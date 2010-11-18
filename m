From: =?UTF-8?B?546L56We?= <oujin.rera@gmail.com>
Subject: dma_mask on scsi_calculate_bounce_limit
Date: Thu, 18 Nov 2010 14:20:43 +0530
Message-ID: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35407 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab0KRIuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 03:50:44 -0500
Received: by yxf34 with SMTP id 34so1686653yxf.19
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 00:50:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I have enabled DMA for my host device and when i connect a scsi device
to the host, it crashes in the following code..

=46unction: scsi_calculate_bounce_limit

=A0if (host_dev && host_dev->dma_mask)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bounce_limit =3D *host_dev->dma_mask;

"*dma_mask" is illegal pointer operation. I would like to understand
is this known and is there reason behind such a code ?

TIA
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

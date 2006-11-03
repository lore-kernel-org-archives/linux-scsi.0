From: <crazyrushstar@yahoo.com.tw>
Subject: dma_alloc_coherent() modify at new kernel
Date: Fri, 3 Nov 2006 17:24:56 +0800 (CST)
Message-ID: <20061103092456.97653.qmail@web18305.mail.tpe.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web18305.mail.tpe.yahoo.com ([203.84.194.87]:52617 "HELO
	web18305.mail.tpe.yahoo.com") by vger.kernel.org with SMTP
	id S1751325AbWKCJY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Nov 2006 04:24:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

At kernel 2.6.18-1.2798.fc6 the DMA_API was modified.

The last arg become useless, but my driver under this
version can not alloc memory.
Every time dma_alloc_coherent will return fail.

How can it work normally?

___________________________________________________=20
 =B1z=AA=BA=A5=CD=AC=A1=A7Y=AE=C9=B3q =A1=D0 =B7=BE=B3q=A1B=AET=BC=D6=A1=
B=A5=CD=AC=A1=A1B=A4u=A7@=A4@=A6=B8=B7d=A9w=A1I=20
 http://messenger.yahoo.com.tw/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

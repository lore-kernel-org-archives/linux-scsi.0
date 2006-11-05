From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] [SCSI] sg.c: SG_DXFER_TO_FROM_DEV mean DMA_BIDIRECTIONAL
Date: Sat, 04 Nov 2006 22:56:45 -0500
Message-ID: <454D60FD.2000806@garzik.org>
References: <20465.60059.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57281 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965821AbWKED4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 22:56:48 -0500
In-Reply-To: <20465.60059.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dougg@torque.net>

Luben Tuikov wrote:
> SG_DXFER_TO_FROM_DEV means DMA_BIDIRECTIONAL, not
> DMA_FROM_DEVICE.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

ACK



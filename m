From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Tue, 09 May 2006 23:19:21 +0100
Message-ID: <1147213161.3172.157.camel@localhost.localdomain>
References: <200605092128.k49LSQ6R024308@mail.hypersurf.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:15316 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751137AbWEIWHf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 18:07:35 -0400
In-Reply-To: <200605092128.k49LSQ6R024308@mail.hypersurf.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: amah@highpoint-tech.com
Cc: linux-scsi@vger.kernel.org, 'Andrew Morton' <akpm@osdl.org>, linux-kernel@vger.kernel.org


> +Non-queued requests (reset/flush etc) can be sent via inbound message
> +register 0. An outbound message with the same value indicates the
> completion
> +of an inbouind message.

One typo..


> +static int iop_wait_ready(struct hpt_iopmu __iomem * iop, u32 millisec)
> +{
> + u32 req = 0;
> + int i;
> +

Your mailer seems to have removed the tabs in the file (at least the
preview version had the formatting correct and this one does not)

If you can't get the mailer not to do this you might want to try
resending it as an attachment if other fixes don't work.

Alan


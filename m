From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Fri, 02 Dec 2005 05:48:16 -0500
Message-ID: <43902670.6000607@pobox.com>
References: <4341A91A.3020000@us.ibm.com> <435E7105.4010105@pobox.com>	 <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com>	 <435EB656.1040502@adaptec.com> <4360FAC1.8020409@us.ibm.com>	 <43850F0D.7040907@torque.net> <43851262.7020807@pobox.com>	 <58cb370e0511240012r64ad150eo90553b230992424e@mail.gmail.com>	 <438FABF8.3020802@pobox.com> <58cb370e0512020007n67f7ba30g7cae84c66b18859@mail.gmail.com> <439021E0.9040203@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:35552 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932720AbVLBKsc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 05:48:32 -0500
In-Reply-To: <439021E0.9040203@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, brking@us.ibm.com, Luben Tuikov <luben_tuikov@adaptec.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, t.schorpp@gmx.de

Douglas Gilbert wrote:
> I noticed that the protocol field in the ATA_12 and
> ATA_16 pass through commands included hard reset,
> SRST and device reset. Would it be useful to implement
> these?

Yes, at least SRST should be implemented.

	Jeff



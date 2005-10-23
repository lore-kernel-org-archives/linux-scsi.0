From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: max_sectors [was Re: [PATCH RFC] yet more struct scsi_lun]
Date: Sun, 23 Oct 2005 16:42:50 +0200
Message-ID: <1130078571.2775.17.camel@laptopd505.fenrus.org>
References: <20051023043301.GA22615@havoc.gtf.org>
	 <20051023070011.GA26569@havoc.gtf.org>  <435B6A62.8070306@torque.net>
	 <1130068390.2775.6.camel@laptopd505.fenrus.org>
	 <435B9DD5.5040907@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3276 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750720AbVJWOnF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 10:43:05 -0400
In-Reply-To: <435B9DD5.5040907@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, michaelc@cs.wisc.edu, Kai.Makisara@kolumbus.fi


> Does anyone know a PCI HBA produced in the last 6 years
> that can't DMA at least 16 MB?

There's only a handful of these, and having these set their max_sectors
isn't a big deal; compared all those other drivers in drivers/scsi



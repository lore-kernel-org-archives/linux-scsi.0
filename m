From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Mon, 10 Jan 2005 07:41:53 +0100
Message-ID: <OFF5A7977B.6DEBE53D-ONC1256F85.00246A36-C1256F85.0024C19A@de.ibm.com>
References: <1105184681.4196.14.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:1449 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S262122AbVAJGld
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 01:41:33 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0A6fWbP205234
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 06:41:32 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0A6gPFq147796
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 07:42:25 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0A6fVAq015413
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 07:41:31 +0100
In-Reply-To: <1105184681.4196.14.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> > this is my next attempt to try to get the patch below merged. Last
> > time Greg KH objected and it didn't get merged.
> > 
> > This patch addresses the following problem: the zfcp device driver
> > creates own sysfs objects and therefore has its own release function
> > within the zfcp device driver itself. 
> 
> would this be solved by using the fc transport class instead, so that
> the scsi layer takes care of all this ?

What would keep the two release functions defined in
scsi_transport_fc.c from being called _after_ the fc transport class
module was unloaded? As usual I might be wrong but this looks like
the same problem to me.

Heiko


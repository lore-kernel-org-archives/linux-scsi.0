From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Mon, 10 Jan 2005 07:53:19 +0100
Message-ID: <OF3362DD9E.0CC252EE-ONC1256F85.0024CE6A-C1256F85.0025CDCC@de.ibm.com>
References: <20050108223326.GB3415@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:9423 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S262122AbVAJGxI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 01:53:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0A6r6dt160268
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 06:53:06 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0A6rpFq167508
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 07:53:51 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0A6qvq4023316
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 07:52:57 +0100
In-Reply-To: <20050108223326.GB3415@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> > this is my next attempt to try to get the patch below merged. Last
> > time Greg KH objected and it didn't get merged.
> 
> As nothing has changed in the patch, I still object to it.  Actually,
> krefs will BUG() out if you try to do this, so I might as well add a
> patch so that kobjects do the same thing...

So what's the fix for this generic (non-zfcp specific) problem then?

Heiko


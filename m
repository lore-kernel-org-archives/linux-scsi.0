From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Mon, 10 Jan 2005 09:10:21 +0100
Message-ID: <OF21502B2A.CFA7983A-ONC1256F85.002AC44A-C1256F85.002CDDA7@de.ibm.com>
References: <20050110070639.GC13078@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:31221 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S262140AbVAJIKI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 03:10:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0A8A7dt071088
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 08:10:07 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0A8AxFq153036
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 09:11:00 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0A89x0f005253
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 09:10:01 +0100
In-Reply-To: <20050110070639.GC13078@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> > > As nothing has changed in the patch, I still object to it. Actually,
> > > krefs will BUG() out if you try to do this, so I might as well add a
> > > patch so that kobjects do the same thing...
> > So what's the fix for this generic (non-zfcp specific) problem then?
> As no other code uses this type of "solution" I don't see how you can
> say it is "generic".

Since you still don't like the patch I would like to know how it should
look like that you would accept it.

Also in my original post I described what the problem is. If that problem
exists then it is generic.
Please see also "Module unloading in a reference counted world"
-> http://lwn.net/Articles/67421/

Heiko


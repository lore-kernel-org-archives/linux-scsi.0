From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Wed, 3 Oct 2007 15:08:48 -0700 (PDT)
Message-ID: <344765.55522.qm@web31815.mail.mud.yahoo.com>
References: <4703FAB0.10702@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:39471 "HELO
	web31815.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755506AbXJCWIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 18:08:49 -0400
In-Reply-To: <4703FAB0.10702@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Jacob <lydianconcepts@gmail.com>, Michael Reed <mdr@sgi.com>, James.Smart@emulex.com, linux-scsi <linux-scsi@vger.kernel.org>

--- Jeff Garzik <jeff@garzik.org> wrote:
> Luben Tuikov wrote:
> > What is needed is persistence, regardless of reboots of what OS
> > is running on the host CPU/system.  SAS WWNs are properties of
> > the SAS target/initiator port, they are not properties of when
> > the host system was booted, or what OS is running on it.
> 
> 
> As part of the previously described schemes, the admin is certainly 
> allowed to choose an option (manual WWN specification) that enables an 
> external system of persistance.
> 
> But such a system should not be a /requirement/, when all an admin might 
> want to do is simply get their card working.

It *is* a requirement, in fact at all levels of the product.

How would you query the storage domain (at boot time mind you) that
no such WWN exists, and/or will not exist when another storage component
is connected to or comes online, if you generated it in the kernel?

SAS ports not having a WWN as part of the MS/NVRAM is an *exception*,
and a bad one at that.  The driver should just complain and not bring
up the HA.

Your "want to get their card working" way of view is very
simplistic to justify generating and assigning SAS WWN in the kernel.
This is the job of the manufacturer/packager, not the host OS.

    Luben


> 
> The admin knows whats best for their site, and may choose.
> 
> 	Jeff


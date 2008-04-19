From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libata: fix boot panic with SATAPI devices on non-SFF
	HBAs
Date: Sat, 19 Apr 2008 09:08:39 -0500
Message-ID: <1208614119.3280.8.camel@localhost.localdomain>
References: <1208542728.3063.25.camel@localhost.localdomain>
	 <fucsch$ah0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54989 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229AbYDSOIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 10:08:43 -0400
In-Reply-To: <fucsch$ah0$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sat, 2008-04-19 at 06:34 -0700, walt wrote:
> James Bottomley wrote:
> > Current 2.6.25 git head now panics reliably on boot if you have a SATAPI
> > device connected.
> >
> > The problem was introduced by the libata merge trying to pull out all
> > the SFF code into a separate module...
> 
> Hi James,
> 
> When I saw your commit I thought it would fix the panic introduced by Tejun's
> commit <305d2a1a>, but no luck.
> 
> I have a pata drive connected to a sata controller using a plugin adapter.
> After Tejun's commit the kernel panics with unknown-block (8,9) instead of
> mounting /dev/sda9.  Is this the scenario your patch is intended to fix?

If it's a panic with a SATA drive, then no it wouldn't ... the problem I
fixed was in SATAPI only (That's CD/DVD/Tape devices).  If you actually
post the boot log and panic, linux-ide and Tejun might be able to help.
Your brief snippet indicates the controller isn't finding sda, I think.

James



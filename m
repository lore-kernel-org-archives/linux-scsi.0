From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: 05 Oct 2004 11:01:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096992068.1765.32.camel@mulgrave>
References: <1096401785.13936.5.camel@localhost.localdomain>	<4162B345.9000806@rtr.ca>
	<1096988167.2064.7.camel@mulgrave> 	<200410051749.22245.oliver@neukum.org>
	<1096991666.2064.25.camel@mulgrave>  <4162C474.8010505@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4527 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270002AbUJEQBT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 12:01:19 -0400
In-Reply-To: <4162C474.8010505@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Oliver Neukum <oliver@neukum.org>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 10:57, Mark Lord wrote:
> James Bottomley wrote:
> >
> > It would add quite a bit of complexity to the reference counted
> > aynchronous model to try and force synchronicity between queuecommand
> > and scsi_remove_host in the mid-layer.  Therefore it's much easier to
> > let the LLD decide what to do with the command.
> 
> Presumably the same is also true for scsi_remove_device() ?

Yes.

James



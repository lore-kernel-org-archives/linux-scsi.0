From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sun, 11 Jan 2004 13:15:31 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401111307500.2644-100000@poirot.grange>
References: <0cb401c3d7da$7f695e00$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:63905 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265854AbUAKMc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jan 2004 07:32:27 -0500
In-Reply-To: <0cb401c3d7da$7f695e00$060ba8c0@AldiP4>
List-Id: linux-scsi@vger.kernel.org
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 11 Jan 2004, Kai Ruhnau wrote:

> > I can load the module for aha152x from these bootdisks and it works.
>
> This precompiled kernel is with aha152x as a module.

See below.

> > But I just tried to use a self-compiled 2.4.10 from the kernel.org sources
> > and it fails.
> > After "scsi0 : Adaptec 152x SCSI driver; $Revision: 2.4 $" I get a timeout
> > and a NULL-pointer dereference.
>
> This one is with aha152x compiled in.

Ok, this proves, that also 2.4.10 manages to handle your controller only
when compiled as a module. What might help you is to compile 2.4.24 with
aha152x as a module - also to boot either from a diskette or with an
initramdisk. If this works, it will give us a good hint where to look
further. Another thing would be to see if SuSE had some patches for
aha152x. Do you have sources for SuSE 2.4.10? Would be interesting to
compare the whole drivers/scsi directories from stock 2.4.10 and that from
SuSE. Also, could be useful to see the decoded Oops from vanilla 2.4.10.

Thanks
Guennadi
---
Guennadi Liakhovetski




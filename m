From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 11:26:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068747998.16444.35.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
	 <1068744259.13580.41.camel@patrh9>
	 <20031113100424.A26197@beaverton.ibm.com>
	 <1068747355.16444.22.camel@patrh9>  <1068747746.16444.30.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:19128 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264374AbTKMS1P
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 13:27:15 -0500
In-Reply-To: <1068747746.16444.30.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > Here we have bInterfaceSubClass = xFF ...
> > That's this device TELLING US THIS DEVICE DOES NOT TALK SCSI.
> ...
> How about we blacklist all the bInterfaceSubClass that Windows does not
> regard as generic.  I remember Windows does regard bInterfaceSubClass =
> x06 as generic.  I think I remember there are two others.

grep -i generic
in windows/inf/usbstor.inf yields, hex:

08 02 50
08 05 50
08 06 50

How about we say disk writable if we do not find bInterfaceSubClass in
the set x 02 05 06?

Pat LaVarre



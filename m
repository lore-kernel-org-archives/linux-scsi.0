From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: 05 Oct 2004 10:54:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096991666.2064.25.camel@mulgrave>
References: <1096401785.13936.5.camel@localhost.localdomain>
	<4162B345.9000806@rtr.ca> <1096988167.2064.7.camel@mulgrave>
	<200410051749.22245.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:64426 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269970AbUJEPyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 11:54:32 -0400
In-Reply-To: <200410051749.22245.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Mark Lord <lsml@rtr.ca>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 10:49, Oliver Neukum wrote:
> Then let the driver tell the upper layers whether the device is still
> connected or not.

Do we have to go over this again?

It would add quite a bit of complexity to the reference counted
aynchronous model to try and force synchronicity between queuecommand
and scsi_remove_host in the mid-layer.  Therefore it's much easier to
let the LLD decide what to do with the command.

James



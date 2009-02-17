From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: BUG - MODE SENSE residue miscount in g_file_storage bulk-only transport ?
Date: Tue, 17 Feb 2009 08:21:58 +0100
Message-ID: <200902170821.58574.stf_xl@wp.pl>
References: <Pine.LNX.4.44L0.0902161122510.15521-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:22330 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZBQHWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 02:22:16 -0500
In-Reply-To: <Pine.LNX.4.44L0.0902161122510.15521-100000@netrider.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Monday 16 February 2009 17:30:35 Alan Stern napisa=C5=82(a):
> > Maybe this is not only problem with MODE SENSE command but with all=
 commands
> > that have allocation length field and file_storage gadget driver BB=
B transport
> > return less data.
> >=20
> > Problem also happens in older kernels, I tried 2.6.27 and 2.6.24 - =
they have this issue.=20
> > Please let me know if have more info or any other help to fix.
>=20
> The problem is in the Atmel hardware; it's not capable of halting a
> bulk endpoint correctly.  You need to invoke g_file_storage with the
> "stall=3Dno" parameter.

I see, it works now, thanks very much.

Stanislaw Gruszka
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

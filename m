From: David Brownell <david-b@pacbell.net>
Subject: Re: BUG - MODE SENSE residue miscount in g_file_storage bulk-only transport ?
Date: Sat, 21 Feb 2009 12:11:39 -0800
Message-ID: <200902211211.39386.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0902161122510.15521-100000@netrider.rowland.org> <200902170821.58574.stf_xl@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:33150 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751729AbZBUULl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2009 15:11:41 -0500
In-Reply-To: <200902170821.58574.stf_xl@wp.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Monday 16 February 2009, Stanislaw Gruszka wrote:
>=20
> > The problem is in the Atmel hardware; it's not capable of halting a
> > bulk endpoint correctly. =A0You need to invoke g_file_storage with =
the
> > "stall=3Dno" parameter.
>=20
> I see, it works now, thanks very much.

Should the driver maybe

	if (gadget_is_at91(g))
		disable stalls;

then?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

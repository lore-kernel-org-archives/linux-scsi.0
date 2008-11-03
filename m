From: Luciano Rocha <luciano@eurotux.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 3 Nov 2008 15:52:55 +0000
Message-ID: <20081103155254.GA3368@bit.office.eurotux.com>
References: <20081028163722.GA4374@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810281331260.2190-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from os.eurotux.com ([216.75.63.6]:38739 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbYKCPxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 10:53:03 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810281331260.2190-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Oct 28, 2008 at 01:38:11PM -0400, Alan Stern wrote:
> > Do you wish me to test anything else?
>=20
> Yes.  Please post a usbmon trace for each of the last two tests.  Tha=
t=20
> is, with the unusual_devs update only, and with the unusual_devs upda=
te=20
> plus the invoke_transport update and the scsi_requeue_command update.

I've updated the bugzilla entry with traces for some combinations of th=
e
discussed patches:
http://bugzilla.kernel.org/show_bug.cgi?id=3D11843

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

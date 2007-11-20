From: Oliver Neukum <oliver@neukum.org>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 16:07:05 +0100
Message-ID: <200711201607.06317.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org> <1195570387.3131.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:48745 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbXKTPHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 10:07:16 -0500
In-Reply-To: <1195570387.3131.12.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

Am Dienstag 20 November 2007 schrieb James Bottomley:
> I don't understand why you want to do this. =C2=A0Power management is=
 a
> layered issue on SCSI, divided (as always) into host, device and
> transport. =C2=A0The idle you're talking about is a pure device thing=
, so it
> can be managed by the ULD (and currently is). =C2=A0When a unit is st=
opped,

The lower layers don't know how to correctly suspend a device. sd_suspe=
nd()
may know how to do it. It would also mean the LLD having to detect idle=
ness.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

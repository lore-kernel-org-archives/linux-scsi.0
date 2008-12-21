From: Oliver Neukum <oliver@neukum.org>
Subject: Re: Suggested patch for testing last sector of USB devices
Date: Sun, 21 Dec 2008 19:25:25 +0100
Message-ID: <200812211925.27140.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0812192009210.16918-100000@netrider.rowland.org> <494E8531.3000205@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:38088 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYLUTaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Dec 2008 14:30:15 -0500
In-Reply-To: <494E8531.3000205@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Am Sonntag, 21. Dezember 2008 19:04:33 schrieb Stefan Richter:
> Alan Stern wrote:
> > --- usb-2.6.orig/include/scsi/scsi_device.h
> > +++ usb-2.6/include/scsi/scsi_device.h
> > @@ -142,6 +142,7 @@ struct scsi_device {
> > =A0=A0=A0=A0=A0=A0unsigned select_no_atn:1;
> > =A0=A0=A0=A0=A0=A0unsigned fix_capacity:1;=A0=A0=A0=A0=A0=A0=A0=A0/=
* READ_CAPACITY is too high by 1 */
> > =A0=A0=A0=A0=A0=A0unsigned guess_capacity:1;=A0=A0=A0=A0=A0=A0/* RE=
AD_CAPACITY might be too high by 1 */
> > +=A0=A0=A0=A0=A0unsigned check_capacity:1;=A0=A0=A0=A0=A0=A0/* Veri=
fy READ_CAPACITY result */
>=20
> Maybe add "ignored if no USB_STORAGE support is built" to the comment
> since it is a no-op otherwise:

Are there really no firewire devices with the same problem?

	Regards
		Oliver

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.27 looping on SCSI errors for bad sectors
Date: Fri, 12 Dec 2008 00:05:34 +0100
Message-ID: <200812120005.35034.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0812111615560.15474-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:35505 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100AbYLKXDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 18:03:50 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812111615560.15474-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Drake <dsd@gentoo.org>, linux-scsi@vger.kernel.org

Am Donnerstag, 11. Dezember 2008 23:02:04 schrieb Alan Stern:
> 2.6.27 does retry the read, indefinitely as far as I can tell. =A0At
> least, if there is a means for giving up eventually, I don't know wha=
t
> it is. =A0My B'' patch provides such a means, but I doubt it will be
> accepted since it would interfere with the operation of some SCSI tap=
e
> devices.

How so?

	Regards
		Oliver

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

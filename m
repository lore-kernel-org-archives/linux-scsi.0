From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Thu, 10 Apr 2014 14:29:54 +0200
Message-ID: <53468EC2.1050000@suse.de>
References: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org> <53467950.3010403@gmail.com> <53468297.1040909@suse.de> <53468DFA.2080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030452AbaDJM34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2014 08:29:56 -0400
In-Reply-To: <53468DFA.2080903@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Reis <andreas.reis@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 04/10/2014 02:26 PM, Andreas Reis wrote:
> Only your 0/3 patch to which Alan linked, along with two other
> patches by Mathias Nyman ("disable usb3 on intel hosts" and "disable
> all lpm related control transfers", one of which is the source of
> the "do nothing"s).
>=20
> I'll revert the latter two and apply the rest of the set. Which I'm
> guessing currently consists of said 0/3 patch =97
> http://www.spinics.net/lists/linux-scsi/msg73502.html
> =97 plus 2/3 and 3/3?
>=20
Yes, that is correct.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

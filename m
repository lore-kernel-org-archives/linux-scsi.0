From: Andreas Schwab <schwab@suse.de>
Subject: Re: Symbios 53C8XX broken on ia64?
Date: Wed, 24 Mar 2004 00:46:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <jeisgvxh2j.fsf@sykes.suse.de>
References: <je3c80ph2o.fsf@sykes.suse.de>
	<1080060468.2091.28.camel@patsy.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:10989 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262943AbUCWXqe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 18:46:34 -0500
In-Reply-To: <1080060468.2091.28.camel@patsy.fc.hp.com> (Alex Williamson's
 message of "Tue, 23 Mar 2004 09:47:48 -0700")
List-Id: linux-scsi@vger.kernel.org
To: Alex Williamson <alex.williamson@hp.com>
Cc: linux-ia64 <linux-ia64@vger.kernel.org>, linux-scsi@vger.kernel.org

Alex Williamson <alex.williamson@hp.com> writes:

>    Seems to work just fine on an rx2600 w/ latest bk plus this patch
> that was being tossed around yesterday:
>
> http://marc.theaimsgroup.com/?l=3Dlinux-ia64&m=3D107999504909154&w=3D=
2
>
> I'm building it statically in my case.

I can't confirm, still fails for me.  I see sym2_init called, but never
sym2_probe.  This is with an Everest (rx5670).

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux AG, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
Key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

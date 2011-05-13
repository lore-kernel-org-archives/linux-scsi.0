From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: aacraid adaptec 6805 support?
Date: Fri, 13 May 2011 17:24:57 +0200
Message-ID: <20110513172457.0db50c93@harpe.intellique.com>
References: <20110513141242.GA1048@apartia.fr>
	<20110513164922.5167ea53@harpe.intellique.com>
	<20110513145420.GA2797@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:36994 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1EMPY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 11:24:57 -0400
In-Reply-To: <20110513145420.GA2797@apartia.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Fri, 13 May 2011 16:54:21 +0200
Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org> =E9crivait=
:

> Ah, but I am trying with 2.6.38.6 and it seems the driver lags behind
> kernel sources.
>=20

It looks like this driver version (1.1-7) will be included in 2.6.39
though, so it should compile against the most current kernel. Or
maybe grab the source from the linux-next tree instead ?

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

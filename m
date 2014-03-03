From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 16:09:44 +0100
Message-ID: <20140303160944.50ba399d@harpe.intellique.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:32482 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbaCCPS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 10:18:56 -0500
In-Reply-To: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Cc: linux-scsi@vger.kernel.org

Le Mon, 3 Mar 2014 14:53:36 +0000
Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:

> lspci -nn (on Dell PowerEdge M520 Blade)
> ...
> 01:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAI=
D
> SAS 2008 [Falcon] [1000:0073] (rev 03)

This one is  supported by the megaraid_sas driver, provided it's recent
enough.=20


> 08:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAI=
D
> SAS 2208 IOV [Thunderbolt] [1000:002f] (rev 05)
> ...

This one seems unsupported. I don't know what it's actually for,
though. Is it the one posing you a problem? I suppose ESXi lets you
check (with modinfo) if megaraid_sas manages it.

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

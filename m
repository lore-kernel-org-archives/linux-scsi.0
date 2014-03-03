From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 18:35:31 +0100
Message-ID: <20140303183531.7ffedbe6@harpe.intellique.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
	<20140303160944.50ba399d@harpe.intellique.com>
	<CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
	<20140303163317.543e9a98@harpe.intellique.com>
	<CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:52799 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbaCCRfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 12:35:36 -0500
In-Reply-To: <CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Cc: linux-scsi@vger.kernel.org

Le Mon, 3 Mar 2014 16:57:44 +0000
Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:

> So I do have ESXi on one of the blade servers. Curiously "lspci -nn"
> output is very different. I for example don't see two RAID controller=
s
> but one:
>=20
> ...
> 00:10.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic
> 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI [1000:0030] (rev 01)
> ...

Strange, do you access the shared storage in this case? Because it
doesn't look at all like the same hardware (different PCI ids, to begin
with).

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

From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 16:33:17 +0100
Message-ID: <20140303163317.543e9a98@harpe.intellique.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
	<20140303160944.50ba399d@harpe.intellique.com>
	<CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:40106 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbaCCPdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 10:33:21 -0500
In-Reply-To: <CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Cc: linux-scsi@vger.kernel.org

Le Mon, 3 Mar 2014 15:22:13 +0000
Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:

> I can't however see the Shared storage provided by the VRTX Enclosure=
=2E
> I would assume one controller is for the internal storage of the M520
> Blade and the other controller for the Shared storage.

Yes, that's probably the case. As I said, I'd first try installing ESXi
on a blade to check what driver it uses for this particular card (ESXi
is a special Linux distro after all).

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

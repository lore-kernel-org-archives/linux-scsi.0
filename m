From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 21:37:12 +0100
Message-ID: <20140303213712.6b226d01@galadriel.home>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
	<20140303160944.50ba399d@harpe.intellique.com>
	<CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
	<20140303163317.543e9a98@harpe.intellique.com>
	<CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
	<20140303183531.7ffedbe6@harpe.intellique.com>
	<CABA7EgDUo5LZAi899-oMMnE5EkuP0GyFSQmtKtc606GG+_nAWA@mail.gmail.com>
	<20140303190535.17a21733@harpe.intellique.com>
	<CABA7EgAFi_Geq2Kf6jAOXOLvrKPbPo+4JwWwOh2FdAmK6bkr5w@mail.gmail.com>
	<CABA7EgC8gpzqMO=J6KvE6KHREJ=KEgEK2bkkPAUSgoLz295Ktw@mail.gmail.com>
	<CABA7EgBFBNdgt6Dj6qHGrPKRMC_JUO4Zqu0OdYcDzv0nh9dNiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:46961 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaCCUhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 15:37:41 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 7604ED1AAA9
	for <linux-scsi@vger.kernel.org>; Mon,  3 Mar 2014 21:37:37 +0100 (CET)
In-Reply-To: <CABA7EgBFBNdgt6Dj6qHGrPKRMC_JUO4Zqu0OdYcDzv0nh9dNiA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Cc: linux-scsi@vger.kernel.org

Le Mon, 3 Mar 2014 18:44:50 +0000 vous =C3=A9criviez:

> Specifically stated "MegaRAID" whilst the Shared PERC 8 does not. In
> the module listing I can't clearly identify any module that would be
> responsible for providing support to the shared PERC 8 controller

Well I went through the module list and couldn't find anything else
that could reasonably fit with an LSI driver, so I'm pretty sure it
must be the megaraid driver... If only it could be a normal Linux
system, alas.

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

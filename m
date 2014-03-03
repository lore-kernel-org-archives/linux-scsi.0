From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 19:05:35 +0100
Message-ID: <20140303190535.17a21733@harpe.intellique.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
	<20140303160944.50ba399d@harpe.intellique.com>
	<CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
	<20140303163317.543e9a98@harpe.intellique.com>
	<CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
	<20140303183531.7ffedbe6@harpe.intellique.com>
	<CABA7EgDUo5LZAi899-oMMnE5EkuP0GyFSQmtKtc606GG+_nAWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:15390 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbaCCSFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 13:05:35 -0500
In-Reply-To: <CABA7EgDUo5LZAi899-oMMnE5EkuP0GyFSQmtKtc606GG+_nAWA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Cc: linux-scsi@vger.kernel.org

Le Mon, 3 Mar 2014 17:56:04 +0000
Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:

> ~ # esxcli system module get -m megaraid_sas
>    Module: megaraid_sas
>    Module File: /usr/lib/vmware/vmkmod/megaraid_sas
>    License: GPL
>    Version: Version 06.801.52.00, Build: 472560, Interface: 9.2 Built
> on: Feb  7 2013
>    Signed Status: Unsigned
>    Signature Issuer:
>    Signature Digest: 50bd fb02 0df9 4ad0 3d99 00de 9234 f055 f7d2 f81=
e
> aadf 7120 a941 44b3 61a6 d3b1
>    Signature FingerPrint: 0000 0000 0000 0000 0000 0000 0000 0000
>    Provided Namespaces:
>    Required Namespaces: com.vmware.driverAPI@9.2.0.0,
> com.vmware.vmkapi@v2_0_0_0

OK so this looks like the normal megaraid_sas under the usual license,
though it obviously works with the weird device:


00:08:00.0 RAID bus controller Mass storage controller: LSI Logic /
Symbios Logic Shared PERC 8 Mini [vmhba2]
Class 0104: 1000:002f

Could you grab the file /usr/lib/vmware/vmkmod/megaraid_sas.ko and run
modinfo on it (even from a different distro, should work fine I
suppose).

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

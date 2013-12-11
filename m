From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: Re: pm8001 =?utf-8?b?aXNzdWXigI8=?=
Date: Wed, 11 Dec 2013 08:48:34 +0000 (UTC)
Message-ID: <loom.20131211T094126-284@post.gmane.org>
References: <DUB109-W122F89F52D37E0B3FD1C137B8DD0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52211 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3LKIzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Dec 2013 03:55:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1VqfZP-00089x-R7
	for linux-scsi@vger.kernel.org; Wed, 11 Dec 2013 09:55:04 +0100
Received: from 59.160.135.215.ill-bgl.static.vsnl.net.in ([59.160.135.215.ill-bgl.static.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2013 09:55:03 +0100
Received: from Suresh.Thiagarajan by 59.160.135.215.ill-bgl.static.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2013 09:55:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Niall Drievers <nialler17 <at> hotmail.com> writes:

>=20
> Jack, Suresh
>=20
> Thanks for your response! Here's what I get from lspci -=C2=A030:00.0=
 Serial=20
Attached SCSI controller:
> PMC-Sierra Inc. Device 8001 (rev 05)=C2=A0
>=20
> cat /sys/class/scsi_host/host7/version_product=C2=A0
> PM8001=C2=A0
>=20
> cat /sys/class/scsi_host/host7/version_fw=C2=A0
> 01.12.02.00

=46irmware version looks old. Please update and let us know.

>=20
> The Kernel version is=C2=A03.13.0-rc2-1.1.
>=20
> Regards,
>=20
> Niall 		 	   		 =20

Regards,
Suresh


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

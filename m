From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Mon, 7 Apr 2008 10:49:40 +0200
Message-ID: <20080407104940.5c7c89d1.taeuber@bbaw.de>
References: <1207327321.3065.12.camel@localhost.localdomain>
	<0631C836DBF79F42B5A60C8C8D4E8229F79E05@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:33160 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbYDGIsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 04:48:12 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229F79E05@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>

Hi there!

Because it might be of interest:

monosan:~ # cat /proc/mpt/version=20
mptlinux-3.04.05
  Fusion MPT base driver
  Fusion MPT SAS host driver
monosan:~ # cat /proc/mpt/ioc0/info=20
ioc0:
  ProductID =3D 0x2202 (LSISAS1068)
  FWVersion =3D 0x01120000
  MsgVersion =3D 0x0105
  FirstWhoInit =3D 0x00
  EventState =3D 0x01
  CurrentHostMfaHighAddr =3D 0x00000000
  CurrentSenseBufferHighAddr =3D 0x00000000
  MaxChainDepth =3D 0x60 frames
  MinBlockSize =3D 0x20 bytes
  RequestFrames @ 0xffff81007db02800 (Dma @ 0x000000007db02800)
    {CurReqSz=3D128} x {CurReqDepth=3D511} =3D 65408 bytes ^=3D 0x10000
    {MaxReqSz=3D128}   {MaxReqDepth=3D511}
  Frames   @ 0xffff81007db00000 (Dma @ 0x000000007db00000)
    {CurRepSz=3D80} x {CurRepDepth=3D128} =3D 10240 bytes ^=3D 0x2880
    {MaxRepSz=3D0}   {MaxRepDepth=3D511}
  MaxDevices =3D 173
  MaxBuses =3D 1
  PortNumber =3D 1 (of 1)



Regards.
Lars


--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

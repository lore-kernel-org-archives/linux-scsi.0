From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: mptsas related problem [2.6.22], LSI SAS1064ET PCI-E
Date: Tue, 18 Sep 2007 18:15:35 +0200
Message-ID: <200709181815.35878.arekm@maven.pl>
References: <664A4EBB07F29743873A87CF62C26D709A718B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:17556 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbXIRQPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 12:15:44 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D709A718B@NAMAIL4.ad.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tuesday 18 of September 2007, Moore, Eric wrote:
> On  Monday, September 10, 2007 11:56 AM, Arkadiusz Miskiewicz wrote:
> > SR2520SAXS platform (S5000VSA mainboard in 2U SR2520 chassis) with
> >
> > 08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064E=
T
> > PCI-Express Fusion-MPT SAS (rev 02)
>
> You have a 1064E B1 part. How much system memory do you have?

4GB on first and 1Gb on second.

> > ps. If someone knows how FwRev=3D01100000h relates to firmware
> > version at
> > http://downloadcenter.intel.com/filter_results.aspx?strTypes=3Da
> > ll&ProductID=3D2487&OSFullName=3DOS+Independent&lang=3Deng&strOSs=3D=
38
> > &submit=3DGo%21
> > then that's also interesting. Simply 01 10 ...=3D=3D 1.16.0.0 ?
>
> 1.16 firmware is Phase 7 firmware, which is over a year old.  Perhaps
> you could attempt upgrading by obtaining it from
> http://www.lsi.com/support/index.html or sending a request to
> support@lsi.com.   Phase 11 just released.

The question is: is it safe to use lsi.com firmware for Intel SR2520SAX=
S=20
platform where SAS1064ET resides on backplane (afaik) ? (There is no ne=
w=20
firmware on intel website).

> > sd 0:0:2:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 0a ad 28 de 00 00 10 00
> > mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abor=
t},
> > SubCode(0x0403)
>
> 0x403 means FRAME_XFER_ERROR, which says your command packet didn't m=
ake
> it.
>
> > mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL}, Code=3D{Rese=
t},
> > SubCode(0x1000)
>
> 0x1000 means SATA_INIT_TIMEOUT
>
> Can you obtain a SAS trace?

Probably, just tell me how to get sas trace.

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

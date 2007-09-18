From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptsas related problem [2.6.22], LSI SAS1064ET PCI-E
Date: Tue, 18 Sep 2007 10:06:29 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709A718B@NAMAIL4.ad.lsil.com>
References: <200709101955.57016.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38911 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbXIRQGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 12:06:54 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200709101955.57016.arekm@maven.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <arekm@maven.pl>, linux-scsi@vger.kernel.org
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On  Monday, September 10, 2007 11:56 AM, Arkadiusz Miskiewicz wrote:

> 
> SR2520SAXS platform (S5000VSA mainboard in 2U SR2520 chassis) with
> 
> 08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064ET 
> PCI-Express Fusion-MPT SAS (rev 02)

You have a 1064E B1 part. How much system memory do you have?

> ps. If someone knows how FwRev=01100000h relates to firmware 
> version at
> http://downloadcenter.intel.com/filter_results.aspx?strTypes=a
> ll&ProductID=2487&OSFullName=OS+Independent&lang=eng&strOSs=38
> &submit=Go%21
> then that's also interesting. Simply 01 10 ...== 1.16.0.0 ?

1.16 firmware is Phase 7 firmware, which is over a year old.  Perhaps
you could attempt upgrading by obtaining it from
http://www.lsi.com/support/index.html or sending a request to
support@lsi.com.   Phase 11 just released.

> sd 0:0:2:0: [sdc] CDB: cdb[0]=0x2a: 2a 00 0a ad 28 de 00 00 10 00
> mptbase: ioc0: LogInfo(0x31120403): Originator={PL}, Code={Abort}, 
> SubCode(0x0403)

0x403 means FRAME_XFER_ERROR, which says your command packet didn't make
it.

> mptbase: ioc0: LogInfo(0x31111000): Originator={PL}, Code={Reset}, 
> SubCode(0x1000)

0x1000 means SATA_INIT_TIMEOUT

Can you obtain a SAS trace?

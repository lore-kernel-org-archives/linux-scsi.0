From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [ANNOUNCE] MPT Fusion driver 3.01.15 update
Date: Thu, 12 Aug 2004 18:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704DE6391@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:14579 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268788AbUHLWBE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 18:01:04 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id i7CM0Icq013004
	for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2004 15:00:18 -0700 (PDT)
Received: from EXA-ATLANTA.se.lsil.com (atl1.se.lsil.com [147.145.16.4])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id i7CM12DM011373
	for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2004 15:01:02 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

All,

We are pleased to announce the MPT Fusion release candidate for lk 2.6

Highlights of this release:
=B7	Patch provided by Christoph Hellwig to remove the isense code.
=B7	Fix compile errors when CONFIG_PROC_FS=3Dn.
=B7	A fix for the module parameter "mptscsih" which was not being
exported.
=B7	The port of the 2.05.17 thru 2.05.23 of the lk 2.4 mpt driver.

The patch for lk 2.6.8-bk series and the driver is available at
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.01.=
15/


Eric Moore
Standard Storage Products Division
LSI Logic Corporation

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

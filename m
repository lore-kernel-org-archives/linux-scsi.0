From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [Fwd: next-2008-0306 scsi/libsas build failure]
Date: Thu, 06 Mar 2008 11:09:18 -0600
Message-ID: <1204823359.3062.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-3btoWBlEIW7hRoDQ+nvX"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55552 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbYCFRJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 12:09:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>


--=-3btoWBlEIW7hRoDQ+nvX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-3btoWBlEIW7hRoDQ+nvX
Content-Disposition: inline
Content-Description: Forwarded message - next-2008-0306 scsi/libsas build
	failure
Content-Type: message/rfc822

Return-Path: <randy.dunlap@oracle.com>
X-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on
	redscar.int.hansenpartnership.com
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=5.0 tests=AWL,BAYES_00,
	RCVD_IN_DNSWL_MED autolearn=ham version=3.2.3
X-Original-To: James.Bottomley@HansenPartnership.com
Delivered-To: James.Bottomley@HansenPartnership.com
Received: from localhost (localhost [127.0.0.1]) by
	accolon.hansenpartnership.com (Postfix) with ESMTP id EB9DA8500 for
	<James.Bottomley@HansenPartnership.com>; Thu,  6 Mar 2008 11:06:10 -0600
	(CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1]) by localhost
	(redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6oPdVsHE1mZG for <James.Bottomley@HansenPartnership.com>;
	Thu,  6 Mar 2008 11:06:09 -0600 (CST)
Received: from agminet01.oracle.com (agminet01.oracle.com
	[141.146.126.228]) by accolon.hansenpartnership.com (Postfix) with ESMTP id
	C2CE581E9 for <James.Bottomley@HansenPartnership.com>; Thu,  6 Mar 2008
	11:06:05 -0600 (CST)
Received: from agmgw2.us.oracle.com (agmgw2.us.oracle.com [152.68.180.213])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id
	m26H5waB000663; Thu, 6 Mar 2008 11:05:58 -0600
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by agmgw2.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id
	m26E6PGu003257; Thu, 6 Mar 2008 10:05:57 -0700
Received: from pool-71-245-99-126.ptldor.fios.verizon.net by
	acsmt359.oracle.com with ESMTP id 8065364331204823137; Thu, 06 Mar 2008
	11:05:37 -0600
Date: Thu, 6 Mar 2008 09:05:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kenrel.org
Cc: jejb <James.Bottomley@HansenPartnership.com>
Subject: next-2008-0306 scsi/libsas build failure
Message-Id: <20080306090533.bdc3783a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Content-Transfer-Encoding: 7bit

drivers/built-in.o: In function `sas_request_addr':
(.text+0x598fb): undefined reference to `request_firmware'
drivers/built-in.o: In function `sas_request_addr':
(.text+0x5998e): undefined reference to `release_firmware'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

drivers/scsi/libsas/sas_scsi_host.c calls request_firmware() and
release_firmware() without checking to see if CONFIG_FW_LOADER=y.

---
~Randy

--=-3btoWBlEIW7hRoDQ+nvX--


From: Daniel Kreling <kreling@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ipr: Driver version 2.6.1
Date: Tue, 31 Mar 2015 10:52:22 -0300
Message-ID: <551AA696.7020900@linux.vnet.ibm.com>
References: <201503261624.t2QGO0AY014263@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:40282 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbbCaNw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 09:52:29 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <kreling@linux.vnet.ibm.com>;
	Tue, 31 Mar 2015 07:52:28 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 9AFFE1FF0026
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 07:43:37 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2VDodWC20512938
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 06:50:39 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2VDqOuc031233
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 07:52:26 -0600
In-Reply-To: <201503261624.t2QGO0AY014263@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

Bump driver version.

Signed-off-by: Brian King
Reviewed-by: Daniel Kreling
---

  drivers/scsi/ipr.h |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h

--- linux/drivers/scsi/ipr.h~ipr_version_2_6_1	2015-03-12=20
16:27:14.235168394 -0500

+++ linux-bjking1/drivers/scsi/ipr.h	2015-03-12 16:27:38.294920049 -050=
0

@@ -39,5 +39,5 @@

/*
=B7*=B7Literals
=B7*/
-#define=B7IPR_DRIVER_VERSION=B7"2.6.0"
-#define=B7IPR_DRIVER_DATE=B7"(November=B716,=B72012)"
+#define=B7IPR_DRIVER_VERSION=B7"2.6.1"
+#define=B7IPR_DRIVER_DATE=B7"(March=B712,=B72015)"

  /*
   * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstandin=
g
_





--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

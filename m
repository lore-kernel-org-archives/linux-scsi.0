From: Daniel Kreling <kreling@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6] ipr: Re-enable write same
Date: Tue, 31 Mar 2015 10:51:14 -0300
Message-ID: <551AA652.8030604@linux.vnet.ibm.com>
References: <201503261623.t2QGNvgx032081@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:42682 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbbCaNvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 09:51:22 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <kreling@linux.vnet.ibm.com>;
	Tue, 31 Mar 2015 07:51:21 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 74FBF1FF0023
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 07:42:30 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2VDpJhv42336474
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 06:51:19 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2VDpHdG026741
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 07:51:18 -0600
In-Reply-To: <201503261623.t2QGNvgx032081@d03av01.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

Re-enable write same support for ipr RAID adapters.

Signed-off-by: Brian King
Reviewed-by: Daniel Kreling
---

  drivers/scsi/ipr.c |    1 -
  1 file changed, 1 deletion(-)


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff -puN drivers/scsi/ipr.c~ipr_write_same drivers/scsi/ipr.c

--- linux/drivers/scsi/ipr.c~ipr_write_same	2015-03-12=20
16:26:04.036892977 -0500

+++ linux-bjking1/drivers/scsi/ipr.c	2015-03-12 16:26:04.044892894 -050=
0

@@ -6404,7 +6404,6 @@

static=B7struct=B7scsi_host_template=B7driver_
=BB .shost_attrs=B7=3D=B7ipr_ioa_attrs,
=BB .sdev_attrs=B7=3D=B7ipr_dev_attrs,
=BB .proc_name=B7=3D=B7IPR_NAME,
-=BB .no_write_same=B7=3D=B71,
=BB .use_blk_tags=B7=3D=B71,
};
_

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

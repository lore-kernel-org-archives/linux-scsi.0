From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: gdth driver 3.04
Date: Wed, 21 Apr 2004 17:40:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B51CDBDEB98C094BB6E1985861F53AF3023913@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54665 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263202AbUDUPke convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:40:34 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i3LDeXg11799
	for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2004 06:40:33 -0700
Received: from nkse2k01.adaptec.com (nkse2k01.adaptec.com [172.28.193.32])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i3LFeXi01622
	for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2004 08:40:33 -0700
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I'm the maintainer of the driver "gdth" for the ICP vortex and Intel RA=
ID controllers. I released the new driver 3.04 with some important chan=
ges. Because the patch for kernel 2.6.5 is bigger than 128k, I send you=
 a link to the patch instead of the patch itself. The link is=20

http://www.icp-vortex.com/ftp/download/rz_neu/linux/temp/gdtp265=20

Here are the commit-messages for the patch:
- Support for drives > 2 TB implemented
- 64-bit DMA support depending on the controller firmware version imple=
mented
- Some important bug fixes made

Thanks,
Achim Leubner

------------------------------------------------------------------
Achim Leubner
Research & Development
ICP vortex Computersysteme GmbH
Gostritzer Str. 61-63
D-01217 Dresden, Germany
Phone: +49-351-871-8291
=46ax: +49-351-871-8448
Email: achim_leubner@adaptec.com
Web: www.icp-vortex.com
------------------------------------------------------------------=A0

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

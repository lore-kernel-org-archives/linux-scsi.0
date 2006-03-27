From: Doug Maxey <dwm@austin.ibm.com>
Subject: [RFC] qla4xxx 2.6.16 status on power5
Date: Mon, 27 Mar 2006 14:03:27 -0600
Message-ID: <200603272003.k2RK3ReI005754@falcon10.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49128 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751106AbWC0UDj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 15:03:39 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2RK3chV031411
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 15:03:38 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2RK3PHs182562
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 15:03:25 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2RK3O9B021457
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 15:03:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Howdy!

Just wanted to pass along the qla4xxx driver on a power5 system has 
successfully completed a 96 hour stress test run with internal tools.
Target was a netapp n3700 with 1 lun per adapter.  The system had 2 
adapters.

The driver tested on 2.6.16
http://marc.theaimsgroup.com/?l=linux-scsi&m=114193951009286&w=4

plus the following patches:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114193946709005&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114193946711722&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830426848&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830426848&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830527117&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830307138&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830505665&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830428477&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830619052&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830530112&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830402866&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830407731&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114177830601763&w=2

++doug


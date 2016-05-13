From: Finn Thain <fthain@telegraphics.com.au>
Subject: RE: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Fri, 13 May 2016 19:25:35 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1605131925290.14186@nippy.intranet>
References: <1462668011.32105.7.camel@petros-ultrathin> <alpine.LNX.2.00.1605081235490.19865@nippy.intranet> <20160509080551.GH29510@mwanda> <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com> <1462829338.1873.4.camel@petroskoutoupis.com>
 <166e07c6f96724c0d1f972f2a65d0a65@mail.gmail.com> <1463017791.5827.4.camel@petros-ultrathin> <20160512062948.GG19274@mwanda> <410ee24683f9720077661b90b0472ce7@mail.gmail.com> <alpine.LNX.2.00.1605131459480.7564@nippy.intranet>
 <567011d5ce3abcd2ad1419985750cb79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33430 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbcEMI1L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2016 04:27:11 -0400
In-Reply-To: <567011d5ce3abcd2ad1419985750cb79@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Petros Koutoupis <petros@petroskoutoupis.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org


On Fri, 13 May 2016, Sumit Saxena wrote:

> 
> For IOs returned by above error are not actually fired to firmware so 
> there will be no interrupt handler called for the same.

You don't need both possibilities to hold. Either one would do it!

-- 

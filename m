From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Disk Errors
Date: Tue, 1 Feb 2005 10:01:25 -0800
Message-ID: <OF971CFEF2.29DF95F4-ON88256F9B.0062D6F5-88256F9B.00630B89@us.ibm.com>
References: <41FF797E.7020009@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e6.ny.us.ibm.com ([32.97.182.146]:13206 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262048AbVBASC0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2005 13:02:26 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j11I2QUP013487
	for <linux-scsi@vger.kernel.org>; Tue, 1 Feb 2005 13:02:26 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j11I2QLC241704
	for <linux-scsi@vger.kernel.org>; Tue, 1 Feb 2005 13:02:26 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j11I2PXb011288
	for <linux-scsi@vger.kernel.org>; Tue, 1 Feb 2005 13:02:26 -0500
In-Reply-To: <41FF797E.7020009@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org

>So there are two situations in which damaged blocks remain
>accessible:
>    1) unrecoverable medium errors
> ...

What's the rationale behind leaving a damaged block accessible in the case 
of an unrecoverable medium error?  A possibility that someone might 
actually be able to recover the data?


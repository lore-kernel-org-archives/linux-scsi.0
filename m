From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Mon, 15 Aug 2016 15:54:50 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D19163952C1@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<yq1lh0cknxb.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
	<yq1tweuvjkl.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394167@avsrvexchmbx1.microsemi.net>
	<yq1h9asrqh6.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394A22@avsrvexchmbx1.microsemi.net>
 <yq160r5oij3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:50602
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752812AbcHOQa2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 12:30:28 -0400
In-Reply-To: <yq160r5oij3.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Friday, August 12, 2016 3:10 PM
> To: Don Brace
> Cc: Martin K. Petersen; jejb@linux.vnet.ibm.com; Viswas G; Mahesh
> Rajashekhara; hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley;
> Scott Benesh; elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi
> driver
> 
> EXTERNAL EMAIL
> 
> 
> >>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:
> 
> Don> Great. So we are good to go?
> 
> I applied the driver to 4.9/scsi-queue. You'll need to come up with a
> migration approach for patch 2.
> 
> --
> Martin K. Petersen      Oracle Linux Engineering

I am thinking that you mean users will need to have some kind of notification that newer kernels will require that the smartpqi driver be configured, especially if they are already booting from the aacraid driver.


Can I submit a smartpqi/Kconfig patch to change the default value to 'y' and add you as a Suggested-by?

We will of course need some documentation as you suggested.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation




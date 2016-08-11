From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Thu, 11 Aug 2016 21:13:48 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916394A22@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<yq1lh0cknxb.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
	<yq1tweuvjkl.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394167@avsrvexchmbx1.microsemi.net>
 <yq1h9asrqh6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0086.outbound.protection.outlook.com ([104.47.32.86]:40113
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751204AbcHKWsy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2016 18:48:54 -0400
In-Reply-To: <yq1h9asrqh6.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, August 10, 2016 9:26 PM
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
> Don,
> 
> >> OK. I was just wondering whether it would make sense to have a libpqi
> >> with all the spec-compliant pieces and put the "smart" in a dedicated
> >> Microsemi driver.
> 
> Don> We would prefer not to do this at this time. We do not know of any
> Don> other PQI drivers that could take advantage of a PQI library.
> Don> However we may end up doing this in the future.
> 
> I understand. But we have been badly burned every single time we
> accepted code on the premise that it would get reworked later.
> 
> That said, I haven't seen much interest in T10 PQI outside of the
> HP/PMC/MS nexus so it's probably not too likely that another driver
> would come along.
> 
> --
> Martin K. Petersen      Oracle Linux Engineering

Great. So we are good to go?

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation




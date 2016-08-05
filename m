From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Fri, 5 Aug 2016 14:19:20 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
 <yq1lh0cknxb.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0068.outbound.protection.outlook.com ([104.47.32.68]:39664
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422677AbcHEOwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2016 10:52:53 -0400
In-Reply-To: <yq1lh0cknxb.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, August 04, 2016 8:25 PM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benesh;
> elliott@hpe.com; linux-scsi@vger.kernel.org
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
> Don> This driver is based on Linus's tree This initial commit contains
> Don> WIP of Microsemi's smartpqi module.
> 
> Is your interface related to T10 PQI?
> 
> --
> Martin K. Petersen      Oracle Linux Engineering

We follow it pretty closely with some exceptions:
 - Our memory BARS includes both the aacraid SIS and PQI interfaces
- We have our own config table defined.
- We are using our own error data buffer schema
- We are not yet supporting fencing and some other features.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation



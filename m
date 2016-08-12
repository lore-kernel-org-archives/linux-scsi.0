From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi driver
Date: Fri, 12 Aug 2016 16:10:24 -0400
Message-ID: <yq160r5oij3.fsf@sermon.lab.mkp.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<yq1lh0cknxb.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
	<yq1tweuvjkl.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394167@avsrvexchmbx1.microsemi.net>
	<yq1h9asrqh6.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394A22@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbcHLUK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 16:10:59 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1916394A22@avsrvexchmbx1.microsemi.net>
	(Don Brace's message of "Thu, 11 Aug 2016 21:13:48 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> Great. So we are good to go?

I applied the driver to 4.9/scsi-queue. You'll need to come up with a
migration approach for patch 2.

-- 
Martin K. Petersen	Oracle Linux Engineering

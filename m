From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi driver
Date: Mon, 08 Aug 2016 21:04:42 -0400
Message-ID: <yq1tweuvjkl.fsf@sermon.lab.mkp.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<yq1lh0cknxb.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbcHIBF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 21:05:28 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
	(Don Brace's message of "Fri, 5 Aug 2016 14:19:20 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

>> Is your interface related to T10 PQI?

Don> We follow it pretty closely with some exceptions: - Our memory BARS
Don> includes both the aacraid SIS and PQI interfaces - We have our own
Don> config table defined.  - We are using our own error data buffer
Don> schema - We are not yet supporting fencing and some other features.

OK. I was just wondering whether it would make sense to have a libpqi
with all the spec-compliant pieces and put the "smart" in a dedicated
Microsemi driver.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi driver
Date: Wed, 10 Aug 2016 22:25:57 -0400
Message-ID: <yq1h9asrqh6.fsf@sermon.lab.mkp.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<yq1lh0cknxb.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
	<yq1tweuvjkl.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394167@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbcHKC2m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 22:28:42 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1916394167@avsrvexchmbx1.microsemi.net>
	(Don Brace's message of "Tue, 9 Aug 2016 15:37:31 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don,

>> OK. I was just wondering whether it would make sense to have a libpqi
>> with all the spec-compliant pieces and put the "smart" in a dedicated
>> Microsemi driver.

Don> We would prefer not to do this at this time. We do not know of any
Don> other PQI drivers that could take advantage of a PQI library.
Don> However we may end up doing this in the future.

I understand. But we have been badly burned every single time we
accepted code on the premise that it would get reworked later. 

That said, I haven't seen much interest in T10 PQI outside of the
HP/PMC/MS nexus so it's probably not too likely that another driver
would come along.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi driver
Date: Tue, 16 Aug 2016 22:28:22 -0400
Message-ID: <yq1fuq4jfi1.fsf@sermon.lab.mkp.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	<yq1lh0cknxb.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163937F2@avsrvexchmbx1.microsemi.net>
	<yq1tweuvjkl.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394167@avsrvexchmbx1.microsemi.net>
	<yq1h9asrqh6.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D1916394A22@avsrvexchmbx1.microsemi.net>
	<yq160r5oij3.fsf@sermon.lab.mkp.net>
	<4993A297653ECB4581FA5C3C31323D19163952C1@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbcHQC26 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2016 22:28:58 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D19163952C1@avsrvexchmbx1.microsemi.net>
	(Don Brace's message of "Mon, 15 Aug 2016 15:54:50 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don,

Don> I am thinking that you mean users will need to have some kind of
Don> notification that newer kernels will require that the smartpqi
Don> driver be configured, especially if they are already booting from
Don> the aacraid driver.

One issue is Kconfig. You need to make sure that make oldconfig will
pull in smartpqi if aacraid was previously selected.

The other issue is that the initrd needs to include the smartpqi
module. Hopefully dracut will handle this correctly now. But please test
that it is working correctly when transitioning from an old kernel with
aacraid to a new kernel with smartpqi.

-- 
Martin K. Petersen	Oracle Linux Engineering

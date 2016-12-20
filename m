From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qedi: fix build, depends on UIO
Date: Tue, 20 Dec 2016 17:49:50 -0500
Message-ID: <yq1wpeu1ai9.fsf@sermon.lab.mkp.net>
References: <26cb8213-7474-0563-67f8-c6b85ee0f024@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32118 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755290AbcLTWu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 17:50:27 -0500
In-Reply-To: <26cb8213-7474-0563-67f8-c6b85ee0f024@infradead.org> (Randy
        Dunlap's message of "Tue, 20 Dec 2016 08:43:30 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.or>, QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Randy" == Randy Dunlap <rdunlap@infradead.org> writes:

Randy> From: Randy Dunlap <rdunlap@infradead.org> Fix build of SCSI qedi
Randy> driver. It uses uio interfaces so it should depend on UIO.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering

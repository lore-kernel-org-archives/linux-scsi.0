From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] ibmvfc: prevent a potential deadlock
Date: Fri, 15 Jul 2016 15:14:24 -0400
Message-ID: <yq1d1meiui7.fsf@sermon.lab.mkp.net>
References: <20160715111857.GC13153@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160715111857.GC13153@mwanda> (Dan Carpenter's message of "Fri,
	15 Jul 2016 14:18:57 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> My static checker complains that we need to unlock on this path.
Dan> Seems true.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvfc: fix WARN_ON during event pool release
Date: Tue, 23 Jul 2019 22:18:49 -0400
Message-ID: <yq1ftmwqinq.fsf@oracle.com>
References: <20190717194827.12514-1-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190717194827.12514-1-tyreld@linux.vnet.ibm.com> (Tyrel
        Datwyler's message of "Wed, 17 Jul 2019 14:48:27 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com, abdhalee@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org


Tyrel,

> While removing an ibmvfc client adapter a WARN_ON like the following
> WARN_ON is seen in the kernel log:

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

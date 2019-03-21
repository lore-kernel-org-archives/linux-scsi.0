From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] ibmvscsi: Protect ibmvscsi_head from concurrent modificaiton
Date: Wed, 20 Mar 2019 20:13:56 -0400
Message-ID: <yq15zsd6q4b.fsf@oracle.com>
References: <20190320184151.31321-1-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190320184151.31321-1-tyreld@linux.vnet.ibm.com> (Tyrel
        Datwyler's message of "Wed, 20 Mar 2019 13:41:50 -0500")
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tyrel,

> For each ibmvscsi host created during a probe or destroyed during a
> remove we either add or remove that host to/from the global
> ibmvscsi_head list. This runs the risk of concurrent modification.
>
> This patch adds a simple spinlock around the list modification calls
> to prevent concurrent updates as is done similarly in the ibmvfc
> driver and ipr driver.

Applied to 5.1/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering

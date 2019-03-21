From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] ibmvscsi: Fix empty event pool access during host removal
Date: Wed, 20 Mar 2019 20:14:13 -0400
Message-ID: <yq11s316q3u.fsf@oracle.com>
References: <20190320184151.31321-1-tyreld@linux.vnet.ibm.com>
        <20190320184151.31321-2-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190320184151.31321-2-tyreld@linux.vnet.ibm.com> (Tyrel
        Datwyler's message of "Wed, 20 Mar 2019 13:41:51 -0500")
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tyrel,

> The event pool used for queueing commands is destroyed fairly early in
> the ibmvscsi_remove() code path. Since, this happens prior to the call
> so scsi_remove_host() it is possible for further calls to queuecommand
> to be processed which manifest as a panic due to a NULL pointer
> dereference as seen here:

Applied to 5.1/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

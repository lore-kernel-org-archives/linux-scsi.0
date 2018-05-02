From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Correct hba_send to include iu_type
Date: Tue, 01 May 2018 23:21:40 -0400
Message-ID: <yq1bmdy7nej.fsf@oracle.com>
References: <20180425162420.612-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180425162420.612-1-david.carroll@microsemi.com> (Dave
        Carroll's message of "Wed, 25 Apr 2018 10:24:20 -0600")
Sender: stable-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Noah Misner <nmisner@us.ibm.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dave,

> commit b60710ec7d7ab ("aacraid: enable sending of TMFs from aac_hba_send()")
>
> allows aac_hba_send() to send scsi commands, and TMF requests, but the existing
> code only updates the iu_type for scsi commands. For TMF requests we are sending
> an unknown iu_type to firmware, which causes a fault.
>
> Include iu_type prior to determining the validity of the command

Applied to 4.17/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

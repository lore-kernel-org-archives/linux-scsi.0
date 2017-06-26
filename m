From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: Don't copy uninitialized stack memory to userspace
Date: Mon, 26 Jun 2017 13:36:56 -0400
Message-ID: <yq11sq6647b.fsf@oracle.com>
References: <20170623140422.30320-1-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170623140422.30320-1-seth.forshee@canonical.com> (Seth
        Forshee's message of "Fri, 23 Jun 2017 09:04:22 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Seth,

> Both aac_send_raw_srb() and aac_get_hba_info() may copy stack
> allocated structs to userspace without initializing all members of
> these structs. Clear out this memory to prevent information leaks.

Applied to 4.13/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

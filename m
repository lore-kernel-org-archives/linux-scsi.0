From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: Change sci_controller_start_task's return type to sci_status
Date: Tue, 16 Oct 2018 21:40:24 -0400
Message-ID: <yq1efcppczb.fsf@oracle.com>
References: <20180927001200.26343-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927001200.26343-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Wed, 26 Sep 2018 17:12:00 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Avoid all of these implicit conversion by just making
> sci_controller_start_task use sci_status. This silences Clang and has
> no functional change since sci_task_status has all of its values
> mapped to something in sci_status.

Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

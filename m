From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler
Date: Tue, 16 Oct 2018 21:40:07 -0400
Message-ID: <yq1in21pczs.fsf@oracle.com>
References: <20180927001150.26212-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927001150.26212-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Wed, 26 Sep 2018 17:11:50 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> -			status = SCI_IO_FAILURE_RESPONSE_VALID;
> +			status = SCI_FAILURE_IO_RESPONSE_VALID;

Naming fail!

Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

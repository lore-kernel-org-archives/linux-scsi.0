From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3] scsi: ibmvscsi: Don't use rc uninitialized in ibmvscsi_do_work
Date: Wed, 05 Jun 2019 21:08:14 +1000
Message-ID: <87woi0mgrl.fsf@concordia.ellerman.id.au>
References: <20190603221941.65432-1-natechancellor@gmail.com> <20190603234405.29600-1-natechancellor@gmail.com> <yq1ef48rc14.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ef48rc14.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:
> Nathan,
>
>> clang warns:
>>
>> drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
>> uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
>>         case IBMVSCSI_HOST_ACTION_NONE:
>>              ^~~~~~~~~~~~~~~~~~~~~~~~~
>
> Applied to 5.3/scsi-queue, thanks!

Thanks all.

cheers

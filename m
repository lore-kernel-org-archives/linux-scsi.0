From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ipr: Fix scsi-mq lockdep issue
Date: Mon, 07 Aug 2017 13:41:54 -0400
Message-ID: <yq18tiv9swt.fsf@oracle.com>
References: <87a83qfosu.fsf@concordia.ellerman.id.au>
        <073ed79c-11ce-e86c-a905-91fd28675d47@kernel.dk>
        <1501166846.2516.1.camel@wdc.com>
        <5b85a365-faa1-3987-9b6b-270399c30686@kernel.dk>
        <87lgn9dqx3.fsf@concordia.ellerman.id.au>
        <92379297-9667-ae52-b05c-6c8a0ce4751c@kernel.dk>
        <OF186C0C54.7E077412-ON8625816B.0053C88E-8625816B.00540312@notes.na.collabserv.com>
        <5dcfe3ac-50c7-86a6-e571-fe5a1c1dc316@linux.vnet.ibm.com>
        <87379c6cfh.fsf@concordia.ellerman.id.au>
        <87a83ju6av.fsf@concordia.ellerman.id.au>
        <6d2bbcc8-3f4b-9b41-45b2-160f4817e439@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6d2bbcc8-3f4b-9b41-45b2-160f4817e439@linux.vnet.ibm.com> (Brian
        King's message of "Tue, 1 Aug 2017 10:21:30 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Brian,

> Fixes the following lockdep warning that can occur when scsi-mq is
> enabled with ipr due to ipr calling scsi_unblock_requests from irq
> context. The fix is to move the call to scsi_unblock_requests to ipr's
> existing workqueue.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: dpt_i2o: Remove VLA usage
Date: Fri, 18 May 2018 12:06:02 -0400
Message-ID: <yq1po1teyol.fsf@oracle.com>
References: <20180502222138.GA22088@beast>
        <CAGXu5jJSQa8WNEOSX7qaPWnGwArx4=X01S+82DQakHP_VY23VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJSQa8WNEOSX7qaPWnGwArx4=X01S+82DQakHP_VY23VA@mail.gmail.com>
        (Kees Cook's message of "Fri, 18 May 2018 08:12:29 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Kees,

>> On the quest to remove all VLAs from the kernel[1] this moves the sg_list
>> variable off the stack, as already done for other allocated buffers in
>> adpt_i2o_passthru(). Additionally consolidates the error path for kfree().
>
> Friendly ping! How does this look for v4.18?

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

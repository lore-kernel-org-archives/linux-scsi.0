From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sas: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 11:56:43 -0400
Message-ID: <yq14lqfb9ac.fsf@oracle.com>
References: <20171025100800.GA145125@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100800.GA145125@beast> (Kees Cook's message of "Wed, 25
        Oct 2017 03:08:00 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, Baoyou Xie <baoyou.xie@linaro.org>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kees,

> In preparation for unconditionally passing the struct timer_list
> pointer to all timer callbacks, switch to using the new timer_setup()
> and from_timer() to pass the timer pointer explicitly. This requires
> adding a pointer to hold the timer's target task, as there isn't a
> link back from slow_task.

Would be good to get John and Jack to take a closer look...

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Wed, 15 Mar 2017 20:07:53 -0400
Message-ID: <yq1r31yf5ie.fsf@oracle.com>
References: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
        (Kefeng Wang's message of "Fri, 3 Mar 2017 18:17:52 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kefeng Wang <wangkefeng.wang@huawei.com> writes:

Kefeng,

> 'n = header_length + block_descriptor_length' could be greater than 512,
> and will lead to oob access, so enlarge transfer buffer to fix it.

Can you share the output of sg_modes -p 0x2a /dev/srN for the offending
drive?

This mode page is usually much smaller than 512 bytes (typically between
32 and 128 bytes).

-- 
Martin K. Petersen	Oracle Linux Engineering

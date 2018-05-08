From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] scsi: arcmsr: Add driver parameter cmd_timeout for scsi command timeout setting
Date: Tue, 08 May 2018 01:41:59 -0400
Message-ID: <yq1in7ywvo8.fsf@oracle.com>
References: <1525675401.8876.9.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525675401.8876.9.camel@Centos6.3-64> (Ching Huang's message of
        "Mon, 07 May 2018 14:43:21 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org


Hello Ching,

> 1. Add driver parameter cmd_timeout, default value is ARCMSR_DEFAULT_TIMEOUT.
> 2. Add slave_configure callback function to set device command timeout value.
> 3. Update driver version to v1.40.00.06-20180504.

I am not so keen on arcmsr overriding the timeout set by the admin or
application.

Also, instead of introducing this module parameter, why not simply ask
the user to change rq_timeout?

-- 
Martin K. Petersen	Oracle Linux Engineering

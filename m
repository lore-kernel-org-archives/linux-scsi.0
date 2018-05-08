From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 0/3] scsi: arcmsr: Add driver parameter cmd_timeout for
 scsi command timeout setting
Date: Tue, 08 May 2018 14:32:46 +0800
Message-ID: <1525761166.4261.8.camel@Centos6.3-64>
References: <1525675401.8876.9.camel@Centos6.3-64>
         <yq1in7ywvo8.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1in7ywvo8.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-05-08 at 01:41 -0400, Martin K. Petersen wrote:
> Hello Ching,
> 
> > 1. Add driver parameter cmd_timeout, default value is ARCMSR_DEFAULT_TIMEOUT.
> > 2. Add slave_configure callback function to set device command timeout value.
> > 3. Update driver version to v1.40.00.06-20180504.
> 
> I am not so keen on arcmsr overriding the timeout set by the admin or
> application.
> 
> Also, instead of introducing this module parameter, why not simply ask
> the user to change rq_timeout?
> 
This timeout setting only after device has been inquiry successfully.
Of course, user can set timeout value to /sys/block/sdX/device/timeout.
But user does not like to set this value once command timeout occurred.
They rather like timeout never happen.

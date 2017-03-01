From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Wed, 1 Mar 2017 09:22:32 +0800
Message-ID: <6a938be6-1ca6-ccb2-2fbe-c5fd323ce8bb@cmss.chinamobile.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
 <58B4BCA5.2060002@redhat.com>
 <983dc030-0352-05d8-9fc7-a6cdf2c59f8d@cmss.chinamobile.com>
 <58B5BDC2.3040300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <58B5BDC2.3040300@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>, Venky Shankar <vshankar@redhat.com>
List-Id: linux-scsi@vger.kernel.org


>>> Write throughput is pretty
>>> low at around 150 MB/s.
>> What's the original write throughput without this patch? Is it also
>> around 80 MB/s ?
> It is around 20-30 MB/s. Same fio args except using --rw=write.
Got it.

Thanks.

BRs
Xiubo

From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [PATCH 0/18] SCSI XCOPY support for the kernel and
 device mapper
Date: Sun, 26 Oct 2014 11:51:55 +0100
Message-ID: <544CD24B.2020505@acm.org>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 10/22/14 15:24, Mikulas Patocka wrote:
> I uploaded the new version of SCSI/device-mapper XCOPY patches here:
> http://people.redhat.com/~mpatocka/patches/kernel/xcopy/series.html
>
> I am also sending the patches in the following emails.

Hello Mikulas,

Which is the base commit of this patch series ? Patch 5/18 fails to 
apply on top of kernel v3.18-rc1 + patches 1..4.

Thanks,

Bart.

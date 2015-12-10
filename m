From: Laura Abbott <labbott@redhat.com>
Subject: Re: [BISECTED] WARNING: CPU: 2 PID: 142 at block/genhd.c:626
 add_disk+0x480/0x4e0()
Date: Thu, 10 Dec 2015 11:05:41 -0800
Message-ID: <5669CD05.9040607@redhat.com>
References: <5668F8C8.6000601@redhat.com> <56692124.6000208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56692124.6000208@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <JBottomley@Odin.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, awilliam@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 12/09/2015 10:52 PM, Hannes Reinecke wrote:
>>
> There's a patchset to update the ALUA handler in Martin Petersens tree which should
>  help here; most notably the commit 'scsi: ignore errors from scsi_dh_add_device()'
>  should fix this particular issue.

Yep, that fixed it. Thanks.

>
> Cheers,
>
> Hannes

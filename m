From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] block: move sd_format_disk_name() into block core
 as disk_name_format()
Date: Fri, 30 Mar 2012 10:56:15 +0100
Message-ID: <1333101375.2833.34.camel@dabdike>
References: <4F7581D4.4040301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
Sender: kvm-owner@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-03-30 at 17:50 +0800, Ren Mingxin wrote:
> 
> This patch series renames "sd_format_disk_name()" to
> "disk_name_format()" and moves it into block core. So
> that who needs formatting disk name can use it, instead
> of duplicating these similar help functions.
> 
> Ren Mingxin (4):
>    block: add function disk_name_format() into block core
>    scsi: replace sd_format_disk_name() to disk_name_format()

These two should be a single patch so it makes it obvious to anyone
looking through the change sets that the code is merely being moved.

Other than that, everything looks fine to me.

James



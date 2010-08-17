From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 10:18:43 +0200
Message-ID: <4C6A45E3.7020005@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org> <201008171046.53220.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201008171046.53220.rusty@rustcorp.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, mst@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 08/17/2010 03:16 AM, Rusty Russell wrote:
> On Tue, 17 Aug 2010 02:22:00 am Tejun Heo wrote:
>> From: Tejun Heo <tj@kernle.org>
>>
>> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
>> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
>> indicate the support for FUA.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> And also for the lguest-specific patch.

Thanks.  Acked-by's added.

-- 
tejun

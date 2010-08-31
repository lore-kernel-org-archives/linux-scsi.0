From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Tue, 31 Aug 2010 10:11:34 +0200
Message-ID: <4C7CB936.8010509@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100830202034.GB12226@quack.quadriga.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 08/30/2010 10:20 PM, Jan Kara wrote:
>   My setup is that I have a dedicated partition / drive for a filesystem
> which is written to from a guest kernel running under KVM. I have set it up
> using virtio driver with cache=writeback so that the host caches the writes
> in a similar way disk caches them. At some point I just kill the qemu-kvm
> process and at that point I'd like to also throw away data cached by the
> host...

$ echo 1 > /sys/block/sdX/device/delete
$ echo - - - > /sys/class/scsi_host/hostX/scan

should do the trick.

Thanks.

-- 
tejun

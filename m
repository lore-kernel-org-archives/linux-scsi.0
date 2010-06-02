From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCHSET] block,libata: implement ->unlock_native_capacity()
Date: Wed, 02 Jun 2010 18:37:57 +0200
Message-ID: <4C0688E5.3010902@gmail.com>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@daveml
List-Id: linux-scsi@vger.kernel.org

On 05/15/2010 08:09 PM, Tejun Heo wrote:
>  0001-buffer-make-invalidate_bdev-drain-all-percpu-LRU-add.patch
>  0002-block-restart-partition-scan-after-resizing-a-device.patch
>  0003-block-ide-simplify-bdops-set_capacity-to-unlock_nati.patch
>  0004-block-use-struct-parsed_partitions-state-universally.patch
>  0005-block-improve-automatic-native-capacity-unlocking.patch
>  0006-SCSI-implement-sd_unlock_native_capacity.patch
>  0007-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
>  0008-libata-implement-on-demand-HPA-unlocking.patch

Jeff, now 0001-0005 are in mainline.  Can you please apply 0006-0008?

Thanks.

-- 
tejun

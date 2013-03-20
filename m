From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V5 4/5] virtio-scsi: introduce multiqueue support
Date: Wed, 20 Mar 2013 15:24:32 +0800
Message-ID: <51496430.6000804@cn.fujitsu.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com>
	<20130320014657.GA14714@google.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20130320014657.GA14714@google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, vsrinivas@ops101.org, pbonzini@redhat.com, mikew@google.com
List-Id: linux-scsi@vger.kernel.org

On 03/20/2013 09:46 AM, Venkatesh Srinivas wrote:
> This looks pretty good!
> 
> I rather like the (lack of) locking in I/O completion (around the req
> count vs. target/queue binding). It is unfortunate that you need to hold the per-target lock in virtscsi_pick_vq() though; have any idea
> how much that lock hurts?

Paolo?

> 
> Just two minor comments:
> 
> (in struct virtio_scsi_target_data):
> +       /* This spinlock never help at the same time as vq_lock. */
>                                ^^^^ held?
> 
> (in struct virtio_scsi):
> +       /* Does the affinity hint is set for virtqueues? */
> Could you rephrase that, please?

Thank you, fixed in V6, please review.

> 
> Tested on qemu and w/ Google Compute Engine's virtio-scsi device.

Cool.

> 
> Reviewed-and-tested-by: Venkatesh Srinivas <venkateshs@google.com>

Do you mind review and test the V6? Thank you.

Regards,
Wanlong Gao

> 
> Thanks,
> -- vs;
> 

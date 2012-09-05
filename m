From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/5] virtio: introduce an API to set affinity for a
	virtqueue
Date: Thu, 06 Sep 2012 09:02:04 +0930
Message-ID: <878vcojbbf.fsf@rustcorp.com.au>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346154857-12487-3-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com
List-Id: linux-scsi@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> From: Jason Wang <jasowang@redhat.com>
>
> Sometimes, virtio device need to configure irq affinity hint to maximize the
> performance. Instead of just exposing the irq of a virtqueue, this patch
> introduce an API to set the affinity for a virtqueue.
>
> The api is best-effort, the affinity hint may not be set as expected due to
> platform support, irq sharing or irq type. Currently, only pci method were
> implemented and we set the affinity according to:
>
> - if device uses INTX, we just ignore the request
> - if device has per vq vector, we force the affinity hint
> - if the virtqueues share MSI, make the affinity OR over all affinities
>   requested
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Applied, thanks.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

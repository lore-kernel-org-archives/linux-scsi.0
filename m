From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/5] virtio-ring: move queue_index to vring_virtqueue
Date: Thu, 06 Sep 2012 09:02:24 +0930
Message-ID: <877gs8jbav.fsf@rustcorp.com.au>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346154857-12487-2-git-send-email-pbonzini@redhat.com>
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
> Instead of storing the queue index in transport-specific virtio structs,
> this patch moves them to vring_virtqueue and introduces an helper to get
> the value.  This lets drivers simplify their management and tracing of
> virtqueues.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Sorry for the delay, I was at Kernel Summit and am only now actually
reading (vs skimming) my backlog.

Putting it in vring_virtqueue rather than virtqueue seems weird, though.
But I've applied as-is, we can clean up that later if we want (probably
by merging the two structures, I'll have to think harder on that).

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

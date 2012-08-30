From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH 0/5] Multiqueue virtio-scsi
Date: Thu, 30 Aug 2012 08:13:42 +0100
Message-ID: <20120830071342.GA6221@stefanha-thinkpad.localdomain>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 28, 2012 at 01:54:12PM +0200, Paolo Bonzini wrote:
> this series adds multiqueue support to the virtio-scsi driver, based
> on Jason Wang's work on virtio-net.  It uses a simple queue steering
> algorithm that expects one queue per CPU.  LUNs in the same target always
> use the same queue (so that commands are not reordered); queue switching
> occurs when the request being queued is the only one for the target.
> Also based on Jason's patches, the virtqueue affinity is set so that
> each CPU is associated to one virtqueue.

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

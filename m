From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/5] Multiqueue virtio-scsi
Date: Thu, 30 Aug 2012 17:45:19 +0200
Message-ID: <503F8A8F.3090709@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<20120830145352.GA21724@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120830145352.GA21724@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 30/08/2012 16:53, Michael S. Tsirkin ha scritto:
>> > this series adds multiqueue support to the virtio-scsi driver, based
>> > on Jason Wang's work on virtio-net.  It uses a simple queue steering
>> > algorithm that expects one queue per CPU.  LUNs in the same target always
>> > use the same queue (so that commands are not reordered); queue switching
>> > occurs when the request being queued is the only one for the target.
>> > Also based on Jason's patches, the virtqueue affinity is set so that
>> > each CPU is associated to one virtqueue.
> 
> Is there a spec patch? I did not see one.

It was already in the first version of the spec, just not implemented
until now.

Paolo

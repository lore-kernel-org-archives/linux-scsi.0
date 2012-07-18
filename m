From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 15:56:02 +0200
Message-ID: <5006C072.2040204@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com>
	<1342561819.18004.470.camel@haakon2.linux-iscsi.org>
	<5006BD3D.7090104@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <5006BD3D.7090104@us.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Il 18/07/2012 15:42, Anthony Liguori ha scritto:
> If you add support for a new command, you need to provide userspace a
> way to disable this command.  If you change what gets reported for VPD,
> you need to provide userspace a way to make VPD look like what it did in
> a previous version.

The QEMU target is not enforcing this to this level.  We didn't for
CD-ROM ATAPI, and we're not doing it for SCSI.

It may indeed be useful for changes to VPD pages or major features.
However, so far we've never introduced any feature that deserved it.
This is also because OSes typically don't care: they use a small subset
of the features and all the remaining "decorations" are only needed to
be pedantically compliant to the spec.

Paolo

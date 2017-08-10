From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
	WARN.
Date: Thu, 10 Aug 2017 22:35:11 +0100
Message-ID: <20170810213511.GB10017@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
	<20170810164035.19963-2-rjones@redhat.com>
	<20170811001447-mutt-send-email-mst@kernel.org>
	<20170810213038.GC20914@redhat.com>
	<20170811003107-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20170811003107-mutt-send-email-mst@kernel.org>
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
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 12:31:44AM +0300, Michael S. Tsirkin wrote:
> Then we probably should fail probe if vq size is too small.

What does this mean?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html

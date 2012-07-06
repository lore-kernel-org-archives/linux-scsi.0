From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 05 Jul 2012 20:13:56 -0700
Message-ID: <1341544436.23954.296.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com>
	<1341453665.23954.224.camel@haakon2.linux-iscsi.org>
	<20120705093113.GC29373@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120705093113.GC29373@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-05 at 12:31 +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 04, 2012 at 07:01:05PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2012-07-04 at 18:05 +0300, Michael S. Tsirkin wrote:

<SNIP>

> > > I was talking about 4/6 first of all.
> > 
> > So yeah, this code is still considered RFC at this point for-3.6, but
> > I'd like to get this into target-pending/for-next in next week for more
> > feedback and start collecting signoffs for the necessary pieces that
> > effect existing vhost code.
> > 
> > By that time the cmwq conversion of tcm_vhost should be in place as
> > well..
> 
> I'll try to give some feedback but I think we do need
> to see the qemu patches - they weren't posted yet, were they?
> This driver has some userspace interface and once
> that is merged it has to be supported.
> So I think we need the buy-in from the qemu side at the principal level.
> 

<nod>

Stefan posted the QEMU vhost-scsi patches a few items, but I think it's
been awhile since the last round of review.  For the recent
development's with tcm_vhost, I've been using Zhi's QEMU tree here:

https://github.com/wuzhy/qemu/tree/vhost-scsi

Other than a few printf I added to help me understand how it works, no
function changes have been made to work with target-pending/tcm_vhost.

Thank you,

--nab

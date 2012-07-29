From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
	VHOST_SCSI_GET_ABI_VERSION
Date: Sun, 29 Jul 2012 15:27:58 +0300
Message-ID: <20120729122758.GE15558@redhat.com>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	<20120724015634.GD4093@kroah.com>
	<1343162724.1813.111.camel@haakon2.linux-iscsi.org>
	<500FF05B.8060602@redhat.com>
	<1343250648.1813.169.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1343250648.1813.169.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Avi Kivity <avi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 25, 2012 at 02:10:48PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2012-07-25 at 16:10 +0300, Avi Kivity wrote:
> > On 07/24/2012 11:45 PM, Nicholas A. Bellinger wrote:
> > 
> > >> > diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
> > >> > index e942df9..3d5378f 100644
> > >> > --- a/drivers/vhost/tcm_vhost.h
> > >> > +++ b/drivers/vhost/tcm_vhost.h
> > >> > @@ -80,7 +80,17 @@ struct tcm_vhost_tport {
> > >> >  
> > >> >  #include <linux/vhost.h>
> > >> >  
> > >> > +/*
> > >> > + * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
> > >> > + *
> > >> > + * ABI Rev 0: All pre 2012 revisions used by prototype out-of-tree code
> > >> > + * ABI Rev 1: 2012 version for v3.6 kernel merge candiate
> > >> > + */
> > 
> > 
> > If it's out of tree, why consider it at all?  Put a stable ABI in tree
> > and extend it in compatible ways.
> > 
> > 
> 
> This comment was supposed to convey that ABI=0 vhost-scsi userspace code
> is not supported with tcm_vhost mainline code.
> 
> But obviously that was not clear enough here.  Updating the comment to
> reflect to make this clear.
> 
> So the main question here was if it's fine to start with ABI=1, and
> require >= ABI=1 for all vhost-scsi userspace code to function with
> tcm_vhost.
> 
> The idea was to avoid confusion for the ABI=0 vhost-scsi code that's
> been floating around for the last 2 years.
> 
> --nab
> 
> 
> 
> 
> 
> 

Yes but I am guessing that code does not invoke the ABI ioctl?

-- 
MST

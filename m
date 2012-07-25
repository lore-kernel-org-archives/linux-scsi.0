From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
	VHOST_SCSI_GET_ABI_VERSION
Date: Wed, 25 Jul 2012 16:10:51 +0300
Message-ID: <500FF05B.8060602@redhat.com>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	<20120724015634.GD4093@kroah.com>
	<1343162724.1813.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1343162724.1813.111.camel@haakon2.linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 07/24/2012 11:45 PM, Nicholas A. Bellinger wrote:

>> > diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
>> > index e942df9..3d5378f 100644
>> > --- a/drivers/vhost/tcm_vhost.h
>> > +++ b/drivers/vhost/tcm_vhost.h
>> > @@ -80,7 +80,17 @@ struct tcm_vhost_tport {
>> >  
>> >  #include <linux/vhost.h>
>> >  
>> > +/*
>> > + * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
>> > + *
>> > + * ABI Rev 0: All pre 2012 revisions used by prototype out-of-tree code
>> > + * ABI Rev 1: 2012 version for v3.6 kernel merge candiate
>> > + */


If it's out of tree, why consider it at all?  Put a stable ABI in tree
and extend it in compatible ways.


-- 
error compiling committee.c: too many arguments to function

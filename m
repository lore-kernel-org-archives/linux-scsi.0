From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
	VHOST_SCSI_GET_ABI_VERSION
Date: Thu, 26 Jul 2012 13:15:26 -0700
Message-ID: <1343333727.22538.3.camel@haakon2.linux-iscsi.org>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	<20120724015634.GD4093@kroah.com>
	<1343162724.1813.111.camel@haakon2.linux-iscsi.org>
	<20120725115552.GB11098@stefanha-thinkpad.localdomain>
	<1343250890.1813.173.camel@haakon2.linux-iscsi.org>
	<20120725223559.GA4786@stefanha-thinkpad.localdomain>
	<1343270061.1813.181.camel@haakon2.linux-iscsi.org>
	<5011069A.2080203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <5011069A.2080203@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Avi Kivity <avi@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-26 at 11:58 +0300, Avi Kivity wrote:
> On 07/26/2012 05:34 AM, Nicholas A. Bellinger wrote:
> > 
> > In that case, respinning a -v5 for tcm_vhost to start from ABI=0 and
> > will post an updated patch shortly.
> > 
> >> The main thing I would like to confirm is that this only versions the
> >> tcm_vhost ioctls?  In that case a single version number works.
> >> 
> > 
> > Correct, the GET_ABI_VERSION call is only intended to identify the
> > changing of tcm_vhost ioctls.
> 
> Why use version numbers at all?
> 

This was a request by QEMU folks.. 


> Feature maps are better, because you can get very fine granularity.
> 
> 

Example..?  If there is a better way to handle ioctl compat I'd
certainly like to hear about it.

From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
	VHOST_SCSI_GET_ABI_VERSION
Date: Sun, 29 Jul 2012 15:35:35 +0300
Message-ID: <20120729123535.GF15558@redhat.com>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	<20120724015634.GD4093@kroah.com>
	<1343162724.1813.111.camel@haakon2.linux-iscsi.org>
	<20120725115552.GB11098@stefanha-thinkpad.localdomain>
	<1343250890.1813.173.camel@haakon2.linux-iscsi.org>
	<20120725223559.GA4786@stefanha-thinkpad.localdomain>
	<1343270061.1813.181.camel@haakon2.linux-iscsi.org>
	<5011069A.2080203@redhat.com>
	<1343333727.22538.3.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1343333727.22538.3.camel@haakon2.linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Avi Kivity <avi@redhat.com>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2012 at 01:15:26PM -0700, Nicholas A. Bellinger wrote:
>  If there is a better way to handle ioctl compat I'd
> certainly like to hear about it.


You basically don't touch exiting commands, always add new ones.
For example if you want to simply stop some ioctl from working
for old userspace, the simplest way is to change ioctl number.


-- 
MST

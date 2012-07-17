From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 00:58:48 +0300
Message-ID: <20120717215848.GD1868@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com>
	<1342559842.18004.440.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1342559842.18004.440.camel@haakon2.linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 17, 2012 at 02:17:22PM -0700, Nicholas A. Bellinger wrote:
> Wrt to staging, I'd like to avoid mucking with staging because:
> 
> *) The code has been posted for review
> *) The code has been converted to use the latest target-core primitives
> *) The code does not require cleanups between staging -> merge
> *) The code has been stable the last 7 days since RFC-v2 with heavy 

BTW I don't suggest putting code itself in staging.  Just the config
flag to enable it.  Once we are more or less sure multiple userspaces
are using this driver, we'll move the config hopefully already in 3.7.
What's the downside?

-- 
MST

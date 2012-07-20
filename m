From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v3 4/4] tcm_vhost: Initial merge for vhost level target
	fabric driver
Date: Fri, 20 Jul 2012 15:03:48 +0300
Message-ID: <20120720120347.GA16550@redhat.com>
References: <1342573172-17421-1-git-send-email-nab@linux-iscsi.org>
	<1342573172-17421-5-git-send-email-nab@linux-iscsi.org>
	<20120718160919.GA2152@redhat.com>
	<1342646458.18004.637.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1342646458.18004.637.camel@haakon2.linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 18, 2012 at 02:20:58PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2012-07-18 at 19:09 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 18, 2012 at 12:59:32AM +0000, Nicholas A. Bellinger wrote:
> 
> <SNIP>
> 
> > > 
> > > Changelog v2 -> v3:
> > > 
> > >   Unlock on error in tcm_vhost_drop_nexus() (DanC)
> > >   Fix strlen() doesn't count the terminator (DanC)
> > >   Call kfree() on an error path (DanC)
> > >   Convert tcm_vhost_write_pending to use target_execute_cmd (hch + nab)
> > >   Fix another strlen() off by one in tcm_vhost_make_tport (DanC)
> > >   Add option under drivers/staging/Kconfig, and move to drivers/vhost/tcm/
> > >   as requested by MST (nab)
> > > 
> > > ---
> > >  drivers/staging/Kconfig       |    2 +
> > >  drivers/vhost/Makefile        |    2 +
> > >  drivers/vhost/tcm/Kconfig     |    6 +
> > >  drivers/vhost/tcm/Makefile    |    1 +
> > >  drivers/vhost/tcm/tcm_vhost.c | 1611 +++++++++++++++++++++++++++++++++++++++++
> > >  drivers/vhost/tcm/tcm_vhost.h |   74 ++
> > >  6 files changed, 1696 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/vhost/tcm/Kconfig
> > >  create mode 100644 drivers/vhost/tcm/Makefile
> > >  create mode 100644 drivers/vhost/tcm/tcm_vhost.c
> > >  create mode 100644 drivers/vhost/tcm/tcm_vhost.h
> > > 
> > 
> > Really sorry about making you run around like that,
> > I did not mean moving all of tcm to a directory,
> > just adding tcm/Kconfig or adding drivers/vhost/Kconfig.tcm
> > because eventually it's easier to keep it all together
> > in one place.
> > 
> 
> Er, apologies for the slight mis-understanding here..  Moving back now +
> fixing up the Kbuild bits.

I'm going offline in several hours and am on vacation for a week
starting tomorrow. So to make 3.6, and if you intend to merge through my
tree, the best bet is if you can send the final version real soon now.

-- 
MST

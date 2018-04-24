From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: simplify procfs code for seq_file instances
Date: Tue, 24 Apr 2018 08:19:16 -0700
Message-ID: <20180424081916.e94ca8463fb3c39ebc082bdd@linux-foundation.org>
References: <20180419124140.9309-1-hch@lst.de> <20180419185750.GD2066@avx2>
 <20180424142304.GE26136@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180424142304.GE26136@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 24 Apr 2018 16:23:04 +0200 Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Apr 19, 2018 at 09:57:50PM +0300, Alexey Dobriyan wrote:
> > >     git://git.infradead.org/users/hch/misc.git proc_create
> > 
> > 
> > I want to ask if it is time to start using poorman function overloading
> > with _b_c_e(). There are millions of allocation functions for example,
> > all slightly difference, and people will add more. Seeing /proc interfaces
> > doubled like this is painful.
> 
> Function overloading is totally unacceptable.
> 
> And I very much disagree with a tradeoff that keeps 5000 lines of 
> code vs a few new helpers.

OK, the curiosity and suspense are killing me.  What the heck is
"function overloading with _b_c_e()"?

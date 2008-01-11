From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Fri, 11 Jan 2008 10:37:29 +0800
Message-ID: <a8e1da0801101837n54e1de5bs8b39c2b79ff10640@mail.gmail.com>
References: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	<Pine.LNX.4.44L0.0801101038580.4267-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0801101038580.4267-100000@iolanthe.rowland.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: a.zummo@towertech.it, krh@redhat.com, rtc-linux@googlegroups.com, SCSI development list <linux-scsi@vger.kernel.org>, peterz@infradead.org, Greg KH <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, James.Bottomley@hansenpartnership.com, cbou@mail.ru, Stefan Richter <stefanr@s5r6.in-berlin.de>, spi-devel-general@lists.sourceforge.net, David Brownell <david-b@pacbell.net>, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Jan 10, 2008 11:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 10 Jan 2008, Dave Young wrote:
>
> > Hi,
> > The patches are done on my side, please help to check.
> >
> > This is the first one of the series about driver core changes.
> > If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).
>
> Before spending too much time on all these conversions, shouldn't you
> first determine whether they will work with the lockdep checker?  In
> one of your earlier messages there was a clear indication that they
> will not.
Thanks.

I managed to build and boot ok with lockdep config options except the
apm_power which need to be cross compiled.

But not sure whether there's something which are not hit yet.
>
> Alan Stern
>
>

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace

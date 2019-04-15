From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Mon, 15 Apr 2019 11:32:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1904151129550.1575-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1904151107350.1575-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1904151107350.1575-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kento.A.Kobayashi@sony.com
Cc: bvanassche@acm.org, martin.petersen@oracle.com, jejb@linux.ibm.com, oneukum@suse.com, gregkh@linuxfoundation.org, usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Apr 2019, Alan Stern wrote:

> On Mon, 15 Apr 2019 Kento.A.Kobayashi@sony.com wrote:
> 
> > Hi
> > 
> > >The unbind happens from inside the SCSI EH callback.  If that really is not allowed, we'll need to change it.  Or we can just change it regardless, since the effort required is pretty small.
> > >
> > >Kento, please try the patch below.  Does it help with your problem?
> > 
> > Thank you for suggestion about this problem.
> > I confirmed your patch fixes this problem.
> 
> Good; I will submit it.

I forgot to ask: Is it okay to add

	Tested-by: Kento Kobayashi <Kento.A.Kobayashi@sony.com>

along with the patch?

Alan Stern

From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH 2/2] usb: storage: scsiglue: Do not skip VPD if
 try_vpd_pages is set
Date: Tue, 18 Jun 2019 07:56:33 -0300
Message-ID: <20190618105631.GB9372@geeko>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
 <20190618013146.21961-3-marcos.souza.org@gmail.com>
 <20190618064947.GB22457@kroah.com>
 <20190618103001.GA9372@geeko>
 <20190618105203.GA18349@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190618105203.GA18349@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, "open list:USB MASS STORAGE DRIVER" <linux-usb@vger.kernel.org>, "open list:USB MASS STORAGE DRIVER" <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2019 at 12:52:03PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 18, 2019 at 07:30:04AM -0300, Marcos Paulo de Souza wrote:
> > On Tue, Jun 18, 2019 at 08:49:47AM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Jun 17, 2019 at 10:31:46PM -0300, Marcos Paulo de Souza wrote:
> > > > If BLIST_TRY_VPD_PAGES is set for a device, even for an USB, it should
> > > > be honored, so only set skip_vpd_pages is try_vpd_pages is not set.
> > > > 
> > > > Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> > > > ---
> > > >  drivers/usb/storage/scsiglue.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > Where is patch 1/2 of this series?
> > 
> > You can find it here:
> > https://lore.kernel.org/lkml/20190618013146.21961-2-marcos.souza.org@gmail.com/
> 
> So is this 2/2 patch independant of 1/2 and can go throught the USB
> tree, or do they both need to be together?

I think it is, since we are not dealing with something specific to a device in
this patch.

> 
> As it is, I have no idea what to do with this patch :(
Sorry, I relied in get_maintainer.pl only, so you weren't CCed in both patches.
But feel free to grab this patch in your tree.
> 
> thanks,
> 
> greg k-h

-- 
Thanks,
Marcos

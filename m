From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2 v4] scsi: ufs: introduce sysfs entries exposing UFS
 health info
Date: Wed, 27 Dec 2017 14:10:52 +0100
Message-ID: <20171227131052.GA13384@kroah.com>
References: <20171220191631.50329-1-jaegeuk@kernel.org>
 <20171220191631.50329-2-jaegeuk@kernel.org>
 <20171220221325.GA56741@jaegeuk-macbookpro.roam.corp.google.com>
 <20171221075935.GB9645@kroah.com>
 <DM5PR04MB10856CCEE145B2B8AADDF668FC070@DM5PR04MB1085.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR04MB10856CCEE145B2B8AADDF668FC070@DM5PR04MB1085.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jaegeuk Kim <jaegeuk@google.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 27, 2017 at 09:00:10AM +0000, Avri Altman wrote:
> 
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
> > Sent: Thursday, December 21, 2017 10:00 AM
> > To: Jaegeuk Kim <jaegeuk@kernel.org>
> > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Jaegeuk Kim
> > <jaegeuk@google.com>
> > Subject: Re: [PATCH 2/2 v4] scsi: ufs: introduce sysfs entries exposing UFS
> > health info
> > 
> > On Wed, Dec 20, 2017 at 02:13:25PM -0800, Jaegeuk Kim wrote:
> > > This patch adds a new sysfs group, namely health, via:
> > >
> > >    /sys/devices/soc/X.ufshc/health/
> As device health is just one piece of information out of the device management,
> I think that you should address this in a more comprehensive way,
> And set hooks for much more device info:
> Allow access to device descriptors, attributes and flags.

Add on patches are easy to create for this if people really want and
need it :)

> The attributes and flags should be placed in separate subfolders

Why?  What is that going to help with?

> The LUN specific descriptors and attributes should be placed in a luns
> subfolder, and then per descriptor / attribute type

Again, why?

> You might also would like to consider differentiating read and write -
> to control those type of accesses as well.

What do you mean by this exactly?

As it is, this is a step forward in getting attributes that people are
asking for and already using, into the kernel tree.  Please don't object
because not all attributes that are possible are being added here, it
should be trivial to add more as needed, right?

I'm really tired of seeing all of the various out-of-tree forks of this
driver, it's about time that someone works to get those features merged,
right?

thanks,

greg k-h

From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 01/13] cciss: remove controllers supported by hpsa
Date: Mon, 25 Oct 2010 17:04:30 -0500
Message-ID: <20101025220430.GA28059@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com> <20101008200606.24279.37953.stgit@beardog.cce.hp.com> <1288037360.5487.730.camel@mulgrave.site> <0F5B06BAB751E047AB5C87D1F77A77887D0E280BD9@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77887D0E280BD9@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Benesh, Scott" <scott.benesh@hp.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "thenzl@redhat.com" <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 25, 2010 at 08:26:54PM +0000, Miller, Mike (OS Dev) wrote:
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Monday, October 25, 2010 3:09 PM
> > To: Stephen M. Cameron
> > Cc: axboe@kernel.dk; akpm@linux-foundation.org; thenzl@redhat.com;
> > Miller, Mike (OS Dev); linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 01/13] cciss: remove controllers supported by hpsa
> > 
> > On Fri, 2010-10-08 at 15:06 -0500, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > >
> > > We would prefer not to have any overlap between the two drivers.
> > > Remove the cciss_allow_hpsa option, as it it is no longer needed.
> > >
> > > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > ---
> > >  drivers/block/cciss.c |   38 +-------------------------------------
> > >  1 files changed, 1 insertions(+), 37 deletions(-)
> > >
> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > > index 5e4fadc..ca900ea 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -66,12 +66,6 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array
> > Controllers");
> > >  MODULE_VERSION("3.6.26");
> > >  MODULE_LICENSE("GPL");
> > >
> > > -static int cciss_allow_hpsa;
> > > -module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
> > > -MODULE_PARM_DESC(cciss_allow_hpsa,
> > > -	"Prevent cciss driver from accessing hardware known to be "
> > > -	" supported by the hpsa driver");
> > > -
> > >  #include "cciss_cmd.h"
> > >  #include "cciss.h"
> > >  #include <linux/cciss_ioctl.h>
> > > @@ -98,18 +92,6 @@ static const struct pci_device_id
> > cciss_pci_device_id[] = {
> > >  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C,
> > 0x3215},
> > >  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C,
> > 0x3237},
> > >  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C,
> > 0x323D},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3241},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3243},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3245},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3247},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3249},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x324A},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x324B},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3250},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3251},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3252},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3253},
> > > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> > 0x3254},
> > 
> > This hunk conflicts with the update Mike Miller sent
> > 
> > commit 6362beea8914cbd4630ccde3617d944aeca2d48f
> > Author: Mike Miller <mike.miller@hp.com>
> > Date:   Tue Oct 19 09:40:34 2010 +0200
> > 
> >     cciss: fix PCI IDs for new Smart Array controllers
> > 
> > And which is now mainline.
> > 
> > James
> 
> I guess I'm the one who jumped the gun on the patch I sent to correct those
> PCI IDs. I suppose it would be preferable to have no overlapping support
> between cciss and hpsa. With the distros it's a little easier to draw a line in
> the sand (or is it?). On some distros it seems migration is impossible, on
> others it's fairly simple.  
> 
> I guess my point is what do users want? Does a significant number want to use
> upstream kernels but they still require cciss? Should we force them to go to
> hpsa? Or should they just add whatever ID they want and go on with life?  
> 
> Maybe if we broke out the PCI IDs into a separate include file for both
> drivers??? Does that help? Probably not. I saw this coming long ago but I still
> don't know the answer. Any ideas, comments, suggestions, flames?  > 

I don't think we want to open this can of worms.  We want disjoint
sets if at all possible.  The only reason they weren't disjoint
sets from the get go was because at the time, nobody had any of
the newer boards, and we needed something to test hpsa on.

>From what I've seen of newer distro betas, the udev stuff does seem to
behave pretty nicely nowadays and one can transparently boot up and mount
filesystems and so on despite swapping out cciss for hpsa or vice
versa without any need to fix anything up.  However, there are
issues.  For example, with the newer distro betas I've seen, The module
load order is not deterministic, and esp. tends to differ in the
kdump initrd case vs. the "normal" initrd kernel case.  If you're
running cciss and hpsa with hpsa_allow_any=1 -- or have other
overlapping device support -- then this means you
can't be certain which driver will get which hardware on any given
boot, which, even though udev makes it mostly work transparently,
it's a bit disconcerting if you aren't expecting it to see all your
filesystems suddenly mounted from strange places, to say the least.
In particular, with overlapping device support, I noticed things
likely to swap around when kdump kernel was loading, with the result
being that the kdump didn't work, because the kdump initrd is a bit
stripped down and lacking in features (I forget now *exactly* what
went wrong, but it was due to some diff between kdump initrd and
the normal initrd in the distro I was looking at.)

All this is avoided if there's no overlapping device support
by default.

I was trying to make things match what we have in our (HP's) variant
of the driver.

Which is to say, cciss should contain:

        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISS,  0x0E11, 0x4070},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSB, 0x0E11, 0x4080},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSB, 0x0E11, 0x4082},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSB, 0x0E11, 0x4083},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSC, 0x0E11, 0x4091},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSC, 0x0E11, 0x409A},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSC, 0x0E11, 0x409B},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSC, 0x0E11, 0x409C},
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSC, 0x0E11, 0x409D},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSA,     0x103C, 0x3225},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3223},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3234},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3235},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3211},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3212},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3213},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3214},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
	{0,}

and

        {0x40700E11, "Smart Array 5300", &SA5_access},
        {0x40800E11, "Smart Array 5i", &SA5B_access},
        {0x40820E11, "Smart Array 532", &SA5B_access},
        {0x40830E11, "Smart Array 5312", &SA5B_access},
        {0x409A0E11, "Smart Array 641", &SA5_access},
        {0x409B0E11, "Smart Array 642", &SA5_access},
        {0x409C0E11, "Smart Array 6400", &SA5_access},
        {0x409D0E11, "Smart Array 6400 EM", &SA5_access},
        {0x40910E11, "Smart Array 6i", &SA5_access},
        {0x3225103C, "Smart Array P600", &SA5_access},
        {0x3223103C, "Smart Array P800", &SA5_access},
        {0x3234103C, "Smart Array P400", &SA5_access},
        {0x3235103C, "Smart Array P400i", &SA5_access},
        {0x3211103C, "Smart Array E200i", &SA5_access},
        {0x3212103C, "Smart Array E200", &SA5_access},
        {0x3213103C, "Smart Array E200i", &SA5_access},
        {0x3214103C, "Smart Array E200i", &SA5_access},
        {0x3215103C, "Smart Array E200i", &SA5_access},
        {0x3237103C, "Smart Array E500", &SA5_access},
        {0x323d103c, "Smart Array P700M", &SA5_access},

and hpsa should contain:

        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSG,     0x103C, 0x3350},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSG,     0x103C, 0x3351},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSG,     0x103C, 0x3352},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSG,     0x103C, 0x3353},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSG,     0x103C, 0x3354},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSG,     0x103C, 0x3355},
        {PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
        {PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
                PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
        {PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
                PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
        {0,}

and

        {0x3241103C, "Smart Array P212", &SA5_access},
        {0x3243103C, "Smart Array P410", &SA5_access},
        {0x3245103C, "Smart Array P410i", &SA5_access},
        {0x3247103C, "Smart Array P411", &SA5_access},
        {0x3249103C, "Smart Array P812", &SA5_access},
        {0x324a103C, "Smart Array P712m", &SA5_access},
        {0x324b103C, "Smart Array P711m", &SA5_access},
        {0x3233103C, "StorageWorks P1210m", &SA5_access},
        {0x333F103C, "StorageWorks P1210m", &SA5_access},
        {0x3350103C, "Smart Array", &SA5_access},
        {0x3351103C, "Smart Array", &SA5_access},
        {0x3352103C, "Smart Array", &SA5_access},
        {0x3353103C, "Smart Array", &SA5_access},
        {0x3354103C, "Smart Array", &SA5_access},
        {0x3355103C, "Smart Array", &SA5_access},


Of course patches to this kind of code tend to be fragile and not have
much of a shelf life.  Sounds like mine had already rotted. 

-- steve

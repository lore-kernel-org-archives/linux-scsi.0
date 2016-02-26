From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild
 test robot
Date: Fri, 26 Feb 2016 23:58:43 +0000
Message-ID: <BY2PR0301MB1654AE617E63D6451B260968A0A70@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1456530314-22250-1-git-send-email-kys@microsoft.com>
 <1456525521.2369.54.camel@HansenPartnership.com>
 <BY2PR0301MB16542D44D55A88410C0C5699A0A70@BY2PR0301MB1654.namprd03.prod.outlook.com>
 <1456529580.2369.60.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1456529580.2369.60.camel@HansenPartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Friday, February 26, 2016 3:33 PM
> To: KY Srinivasan <kys@microsoft.com>; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com; hare@suse.de
> Subject: Re: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild test
> robot
> 
> On Fri, 2016-02-26 at 23:22 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley
> [mailto:James.Bottomley@HansenPartnership.com
> > > ]
> > > Sent: Friday, February 26, 2016 2:25 PM
> > > To: KY Srinivasan <kys@microsoft.com>; linux-kernel@vger.kernel.org
> > > ;
> > > devel@linuxdriverproject.org; ohering@suse.com;
> > > jbottomley@parallels.com; hch@infradead.org;
> > > linux-scsi@vger.kernel.org;
> > > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > > martin.petersen@oracle.com; hare@suse.de
> > > Subject: Re: [PATCH 1/1] scsi: storvsc: Fix a build issue reported
> > > by kbuild test
> > > robot
> > >
> > > On Fri, 2016-02-26 at 15:45 -0800, K. Y. Srinivasan wrote:
> > > > tree:
> > > > https://na01.safelinks.protection.outlook.com/?url=https%3a%2
> > > >
> f%2fgit.kernel.org%2fpub%2fscm%2flinux%2fkernel%2fgit%2ftorvalds%
> > > > 2fli
> > > >
> > >
> nux.git&data=01%7c01%7ckys%40microsoft.com%7ce2e0622715844b79ad71
> > > 08d3
> > > >
> > >
> 2796ec3c%7c72f988bf86f141af91ab2d7cd011db47%7c1&sdata=ubr4GbBaNS
> > > %2ftO
> > > > z%2buJBk0CL9N0UNG9x2TidLgy6Yovg4%3d master
> > > > head:   03c21cb775a313f1ff19be59c5d02df3e3526471
> > > > commit: dac582417bc449b1f7f572d3f1dd9d23eec15cc9 storvsc:
> > > > Properly
> > > > support Fibre Channel devices
> > > > date:   3 weeks ago
> > > > config: x86_64-randconfig-s3-01281016 (attached as .config)
> > > > reproduce:
> > > >         git checkout dac582417bc449b1f7f572d3f1dd9d23eec15cc9
> > > >         # save the attached .config to linux build tree
> > > >         make ARCH=x86_64
> > > >
> > > > All errors (new ones prefixed by >>):
> > > >
> > > >    drivers/built-in.o: In function `storvsc_remove':
> > > > > > storvsc_drv.c:(.text+0x213af7): undefined reference to
> > > > > > `fc_remove_host'
> > > >    drivers/built-in.o: In function `storvsc_drv_init':
> > > > > > storvsc_drv.c:(.init.text+0xcbcc): undefined reference to
> > > > > > `fc_attach_transport'
> > > > > > storvsc_drv.c:(.init.text+0xcc06): undefined reference to
> > > > > > `fc_release_transport'
> > > >    drivers/built-in.o: In function `storvsc_drv_exit':
> > > > > > storvsc_drv.c:(.exit.text+0x123c): undefined reference to
> > > > > > `fc_release_transport'
> > > >
> > > > With this commit, the storvsc driver depends on FC atttributes.
> > > > Make
> > > > this
> > > > dependency explicit.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > > > ---
> > > >  drivers/scsi/Kconfig |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > > > index 64eed87..24365c3 100644
> > > > --- a/drivers/scsi/Kconfig
> > > > +++ b/drivers/scsi/Kconfig
> > > > @@ -594,6 +594,7 @@ config XEN_SCSI_FRONTEND
> > > >  config HYPERV_STORAGE
> > > >  	tristate "Microsoft Hyper-V virtual storage driver"
> > > >  	depends on SCSI && HYPERV
> > > > +	depends on SCSI_FC_ATTRS
> > >
> > > Well, I suppose continually sending the wrong patch until I get
> > > annoyed
> > > enough to send the right one is one way of doing it.  This patch is
> > > wrong. what you want is below.
> >
> > James, that was not my intent; although it is a tempting strategy!
> > Here is an excerpt of your comments on v2 of this patch:
> > (dated Jan 29 of this year):
> >
> > "No ... if you want to depend on the FC_ATTRS then a simple depend
> > works.  If you want to be able to build without them or with them,
> > then
> > that line must read
> >
> > depends on m || SCSI_FC_ATTRS != m"
> >
> > Since all I wanted was to depend on FC_ATTRS I chose to go with your
> > recommendation -
> > which also happened to be what I had initially sent (v1 of this
> > patch).
> 
> If you're going to depend on the FC_ATTRS then you don't need all of
> the
> 
> #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> 
> In the driver, because you're never building without it.  I thought
> those were put in to satisfy Hannes' request that the driver be
> buildable without the attributes?
> 
> > > You want HYPERV_STORAGE to be built in if the FC attributes are,
> > > otherwise you don't care because if they're N the FC code will be
> > > compiled out.
> >
> > If FC attributes are built in, I have no issue - I want to be able to
> > build the storvsc driver both as a module as well as built in.
> > However, if storvsc is built as part of the kernel, I want to make
> > sure that FC attributes are also built as part of the kernel. The
> > build test failure that was reported was this case. With this patch,
> > the build issue reported by kbuild cannot happen since if the
> > FC_ATTRS are built as a module, storvsc cannot be builtin.
> 
> Oh, right, the line should read
> 
> depends on m || SCSI_FC_ATTRS != m
> 
> for that case.

Thanks James. I tested your suggestion and I will send out the updated version of the patch.

Regards,

K. Y

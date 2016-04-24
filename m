From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH 2/8] char: rpmb: add sysfs-class ABI documentation
Date: Sun, 24 Apr 2016 16:27:54 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542452C5@hasmsx108.ger.corp.intel.com>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
 <1459676572-29921-3-git-send-email-tomas.winkler@intel.com>
 <20160424091951.GA23015@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160424091951.GA23015@amd>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> 
> On Sun 2016-04-03 12:42:46, Tomas Winkler wrote:
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-class-rpmb | 15 +++++++++++++++
> >  MAINTAINERS                                |  1 +
> >  2 files changed, 16 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-rpmb
> >
> > diff --git a/Documentation/ABI/testing/sysfs-class-rpmb
> > b/Documentation/ABI/testing/sysfs-class-rpmb
> > new file mode 100644
> > index 000000000000..62d1959bf19e
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-rpmb
> > @@ -0,0 +1,15 @@
> > +What:		/sys/class/rpmb/
> > +Date:		Mar 2016
> > +KernelVersion:	TBD
> > +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> > +Description:
> > +		The rpmb/ class sub-directory belongs to RPMB device class
> > +
> > +
> > +What:		/sys/class/rpmb/rpmbN/
> > +Date:		Mar 2016
> > +KernelVersion:	TBD
> > +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> > +Description:
> > +		The /sys/class/rpmb/rpmbN directory is created for
> > +		each RPMB registered device
> 
> 
> Umm. Can we get some better documentation?
> 
> This is useless.
> 
> Interested reader would also like to know what "RPMB" is, and why he
> should be interested...

No, problem I'll paste here some information from the intro mail.
Thanks 
Tomas 

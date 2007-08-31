From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/3] debloat aic7xxx and aic79xx drivers
Date: Fri, 31 Aug 2007 16:17:05 +0100
Message-ID: <200708311617.05972.vda.linux@googlemail.com>
References: <200708311613.59666.vda.linux@googlemail.com> <200708311615.54991.vda.linux@googlemail.com> <200708311616.36251.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xDD2GdM17UtWJ4G"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965640AbXHaPRd@vger.kernel.org>
In-Reply-To: <200708311616.36251.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_xDD2GdM17UtWJ4G
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 31 August 2007 16:16, Denys Vlasenko wrote:
> On Friday 31 August 2007 16:15, Denys Vlasenko wrote:
> > On Friday 31 August 2007 16:13, Denys Vlasenko wrote:
> > > Attached are three patches which fix that:
> > > 
> > >    text    data     bss     dec     hex filename
> > >  261433   50018    1172  312623   4c52f linux-2.6.23-rc1.org.t/drivers/scsi/aic7xxx/built-in.o
> > >  199654   50018    1172  250844   3d3dc linux-2.6.23-rc1.aic.t/drivers/scsi/aic7xxx/built-in.o
> > >  184014   21314    1172  206500   326a4 linux-2.6.23-rc1.aic1.t/drivers/scsi/aic7xxx/built-in.o
> > >  202378    2850    1172  206400   32640 linux-2.6.23-rc1.aic2.t/drivers/scsi/aic7xxx/built-in.o
> > > 
> > > 1-debloat.patch    deinlines a lot of functions
> > > 2-addstatic.patch  adds statics, #ifdefs out huge amount of unused code, adds consts
> > > 3-addconst.patch   adds more consts
--
vda

--Boundary-00=_xDD2GdM17UtWJ4G
Content-Type: application/x-bzip2;
  name="linux-2.6.23-rc1-aic7xxx-3-addconst.patch.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="linux-2.6.23-rc1-aic7xxx-3-addconst.patch.bz2"

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
zF3JFOFCQm6fhGw=

--Boundary-00=_xDD2GdM17UtWJ4G--

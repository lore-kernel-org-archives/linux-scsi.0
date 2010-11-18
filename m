From: Greg KH <greg@kroah.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 18 Nov 2010 13:46:19 -0800
Message-ID: <20101118214619.GA29097@kroah.com>
References: <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
 <20101113235938.GA1827@kroah.com>
 <4CE1017E.4090409@panasas.com>
 <20101115161620.GB5981@kroah.com>
 <4CE16B8E.1000300@panasas.com>
 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
 <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com>
 <4CE2846C.6070501@vlnb.net>
 <4CE59482.3050002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE59482.3050002@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Cc: Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2010 at 12:02:58AM +0300, Vladislav Bolkhovitin wrote:
> Since nobody objected, Greg, could you consider to ACK SCST SYSFS
> management interface in /sys/kernel/scst_tgt/, please? Please find the
> SCST SYSFS ABI documentation file you requested below.

No, sorry, again, you should not be using kobjects, and do not polute
the main /sys/kernel/ namespace with this.

Use 'struct device' please, that is what it is there for, and is what
the rest of the kernel is using.  And use the rest of the
driver/bus/device infrastructure as your model will work with it just
fine.

Yes, I know you said you didn't think you could use it, and that your
code was different than everyone elses, but I still do not believe it,
sorry.

good luck,

greg k-h

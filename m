From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Wed, 18 Jul 2018 19:45:31 +0200
Message-ID: <20180718174531.GA2008@kroah.com>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
 <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
 <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
 <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
 <4cb931e199599314829f5ff750797c88fc123f1f.camel@wdc.com>
 <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
 <aa697186c00937c18519fe5eb1355d3fc458cfb6.camel@wdc.com>
 <20180718085651.GA23599@kroah.com>
 <16c8acaec092ef989ec20d0b006a434bc0de250c.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16c8acaec092ef989ec20d0b006a434bc0de250c.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 18, 2018 at 05:30:07PM +0000, Bart Van Assche wrote:
> On Wed, 2018-07-18 at 10:56 +0200, gregkh@linuxfoundation.org wrote:
> > On Tue, Jul 17, 2018 at 09:06:35PM +0000, Bart Van Assche wrote:
> > > On Tue, 2018-07-17 at 13:23 -0700, Evan Green wrote:
> > > > I'm not dead set on binary, since as above I could do it either way,
> > > > but it seemed worth at least talking through. Let me know what you
> > > > think.
> > > 
> > > The configfs documentation (Documentation/filesystems/configfs/configfs.txt)
> > > is clear about this: "Preferably only one value per file should be used." So
> > > I would like to hear the opinion of someone who has more authority than I
> > > with regard to configfs.
> > 
> > Don't we have "binary" files for configfs?  We have them for sysfs, they
> > are for files that are not touched by the kernel and just "pass-through"
> > to the hardware.  Would that work here as well?
> 
> If a new version of the UFS spec would be introduced and that new version of the
> spec introduces a new layout for the binary descriptor, will it be possible for
> user space software to figure out which version of the binary descriptor format
> that has to be used?

If a new UFS spec was crazy enough to keep the same field name but
change the layout of the field, well, the UFS spec authors deserve all
of the pain and suffering that would cause to be heaped on them.

Seriously, it's not hard to do this right, go fix the spec before they
do something stupid.

And you are reporting the version of the UFS spec that your device
supports to userspace, right?  So is this really a problem even if the
spec authors are that foolish?

thanks,

greg k-h

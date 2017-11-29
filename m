From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: UFS utilities
Date: Wed, 29 Nov 2017 08:20:21 -0800
Message-ID: <1511972421.3222.6.camel@HansenPartnership.com>
References: <e8aa9f0b9e854fe6bff7cb17dc08ce8c@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <e8aa9f0b9e854fe6bff7cb17dc08ce8c@SIWEX5A.sing.micron.com>
Sender: stable-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-11-29 at 15:39 +0000, Bean Huo (beanhuo) wrote:
> Thread-Topic: UFS utilities
>  Thread-Index: AdNpKDYJWTPjczfxQHC/pD9WNnnl4w==

Could you fix your mail transfer agent?  It's using these non standard
headers instead of the RFC mandated In-Reply-To: and References:

The problem is that this breaks threading on the public mailing lists
and means most of us can't tie this email back to the original thread.

> > On Mon, Nov 27, 2017 at 11:25:47AM +0000, Bean Huo (beanhuo) wrote:
> > > 
> > > Hi, all
> > > Is there someone knows if exists one utilis dedicated to UFS
> > > device, rather than SCSI utils?
> > > 
> > > I have tried sg3-utils, but it is not convenient for the embedded
> > > ARM-based system.
> > > 
> > > And also it doesn't support several UFS special command.
> > 
> > What specific UFS commands do you need to make to the device that
> > the current driver does not support?
> 
> 
> There are some UFS/vendor native commands. They are not SCSI based.

Can you list them?  The reason for asking is that SCSI-3 is pretty
extensive in terms of management utilities, so any function you do with
vendor native commands that matches an sg3utils function could be done
by the latter instead via a SCSI translation layer.

James

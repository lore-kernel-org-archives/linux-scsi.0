From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add Marvell UMI driver
Date: Wed, 20 Apr 2011 11:17:00 -0700
Message-ID: <20110420181700.GA8143@kroah.com>
References: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
 <20110420142626.GA22114@kroah.com>
 <BANLkTimL4ndgb7FRkr393AD=yOCVyJ1QuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimL4ndgb7FRkr393AD=yOCVyJ1QuA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: li jianyun <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2011 at 10:58:30PM +0800, li jianyun wrote:
> Hi Grep KH
>       thanks for your remind,I am a beginner=EF=BC=8Cand don't know h=
ow to
> send patch to kernel.
> I will update the Signed-off-by. Do I need update the subject to
> "[PATCH][RESEND] Add Marvell UMI driver" when I resend this patch?
>      thanks for your patient.

No, just do:
	[patch v2]
as git will strip out the first set of [] markings, but not the second
when applying the patch.

thanks,

greg k-h

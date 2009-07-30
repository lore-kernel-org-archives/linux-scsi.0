From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 12:40:41 +0200
Message-ID: <20090730104041.GA23926@merkur.ravnborg.org>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <20090729162844.GA22561@merkur.ravnborg.org> <1248885456.3900.48.camel@mulgrave.site> <4A7166A3.70509@panasas.com> <20090730093403.GA11381@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752948AbZG3Kkq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090730093403.GA11381@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2009 at 12:34:03PM +0300, Michael S. Tsirkin wrote:
> On Thu, Jul 30, 2009 at 12:23:47PM +0300, Boaz Harrosh wrote:
> > >> I did a quick diff of the glibc provided scsi.h and kernel scsi.h.
> > >> >From a quick look it seems that we have more in the kernel version
> > >> than the glibc version - and no obvious conflicts.
> > >>
> > 
> > exactly it is original Kernel headers from the time they where sampled
> > last by glibc.
> 
> glibc also added
> #include <features.h>
> in some of them.
> Donnu why.

Browsing features.h this looked unused (by scsi.h) to me.

	Sam

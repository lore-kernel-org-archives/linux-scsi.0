From: Greg KH <greg@kroah.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 8 Jul 2011 09:32:19 -0700
Message-ID: <20110708163219.GB2646@kroah.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
 <20110708145408.GA2283@kroah.com>
 <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
 <20110708154736.GA7320@kroah.com>
 <1310140451.3282.85.camel@mulgrave>
 <20110708160403.GB31500@kroah.com>
 <1310141857.3282.87.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1310141857.3282.87.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 08, 2011 at 11:17:36AM -0500, James Bottomley wrote:
> On Fri, 2011-07-08 at 09:04 -0700, Greg KH wrote:
> > Do you seriously think that this sysfs attribute can be removed someday
> > in the future if we get structured logging implemented?  It can't,
> > sorry, people will start depending on this and their jury-rigged
> > implementations will require it no matter what we do otherwise.
> 
> Yes, it can.  The way we do that is to make udev the interface to this
> and the sysfs file becomes an internal udev implementation, not an
> external ABI.

No, sorry, you just described the "external" abi in the
Documentation/ABI directory.

> Any program using it rather than udev that breaks, well, tough, it
> used the wrong interface.

Again, no, we can't do that as you should well know.

And see Kay's response as to how udev will not be using this interface
by default anyway, so I don't see how you will ever be able to remove
this sysfs file once it is added.

greg k-h

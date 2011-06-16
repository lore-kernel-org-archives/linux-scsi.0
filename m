From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Thu, 16 Jun 2011 19:02:33 +0100
Message-ID: <20110616180233.GN11521@ZenIV.linux.org.uk>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com>
 <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave>
 <4DFA3E1A.9050207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DFA3E1A.9050207@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2011 at 01:32:10PM -0400, Douglas Gilbert wrote:

> As James' notes each storage device can only have one
> "preferred name" at a time. But how can that preferred name
> be represented in sysfs ? If /sys/block/<kernel_name>
> suddenly changed to /sys/block/<preferred_name> that would
> be very disruptive. I would prefer something like
> /sys/class/block_preferred_name/<preferred_name> was introduced
> as a symlink to /sys/block/<kernel_name> but that would require
> that all <preferred_name>s were unique. [Not a bad restriction
> IMO]. If the <preferred_name> was only placed in the
> /sys/block/<kernel_name> directory that would be ugly from
> the user space tool point of view.

Oh, rapture... so now we can expect the container crowd to introduce
yet *another* "namespace" ;-/

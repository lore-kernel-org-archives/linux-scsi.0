From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] lpfc : add module parameter that allows adapter	instances to avoid attachment
Date: Fri, 27 Mar 2009 10:14:48 -0600
Message-ID: <20090327161448.GM8014@parisc-linux.org>
References: <1238097300.27023.2.camel@ogier> <1238098747.3342.54.camel@localhost.localdomain> <49CBE772.80304@emulex.com> <1238100849.3342.58.camel@localhost.localdomain> <20090327150940.GK8014@parisc-linux.org> <1238168037.3292.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41257 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZC0QPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2009 12:15:08 -0400
Content-Disposition: inline
In-Reply-To: <1238168037.3292.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Mar 27, 2009 at 03:33:57PM +0000, James Bottomley wrote:
> Actually they better be ... we'll get into real trouble if they're not
> because of the way we flatten the space for multiple bus binding
> drivers.

Er ... where do we do that?  As far as I'm aware, to bind to multiple
busses, you register multiple foo_driver.  They're separate namespaces.

> Even if I accepted your argument, I still can't see why we'd only
> implement this for PCI, and thus why it shouldn't be in the generic
> device part (except possibly with a bus type name qualifier).

Adding the bus name qualifier would work.  It seems like much more typing,
in order to get what advantage over just implementing it for PCI?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

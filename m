From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] lpfc : add module parameter that allows adapter	instances to avoid attachment
Date: Fri, 27 Mar 2009 09:11:40 -0600
Message-ID: <20090327151139.GL8014@parisc-linux.org>
References: <1238097300.27023.2.camel@ogier> <1238098747.3342.54.camel@localhost.localdomain> <49CBE772.80304@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52610 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbZC0PLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2009 11:11:42 -0400
Content-Disposition: inline
In-Reply-To: <49CBE772.80304@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Mar 26, 2009 at 04:37:06PM -0400, James Smart wrote:
> The oem requirement we have explicitly states not to use the unbind 
> interface
> (we proposed unbind at first as well).
> 
> The issue is what happens on the link while we are bound for that short
> amount of time. It confuses the things on the other side of the link.
> There's a secondary driver that ends up binding to the adapters we exclude,
> and the things on the other side only expected to see the second driver.

By the way, are these interfaces real or virtual (SR-IOV virtual)?  PCI
bus numbers aren't the most stable way of referring to devices any more.
I don't suppose we can key this off PCIe DSN, can we?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

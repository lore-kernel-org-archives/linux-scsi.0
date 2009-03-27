From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] lpfc : add module parameter that allows adapter	instances to avoid attachment
Date: Fri, 27 Mar 2009 09:09:40 -0600
Message-ID: <20090327150940.GK8014@parisc-linux.org>
References: <1238097300.27023.2.camel@ogier> <1238098747.3342.54.camel@localhost.localdomain> <49CBE772.80304@emulex.com> <1238100849.3342.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52605 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZC0PJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2009 11:09:58 -0400
Content-Disposition: inline
In-Reply-To: <1238100849.3342.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Mar 26, 2009 at 03:54:09PM -0500, James Bottomley wrote:
> Also (as Randy pointed out) you don't account for the domain.  However,
> you could just by not bothering to convert the string to numbers for the
> compare, just compare on dev->bus_id ... which is how a generic one
> would work.

I think it needs to be PCI and not device core.  bus_id isn't guaranteed
to be unique between different bus types.  I don't know of any that
conflict, but we don't want to inadvertently disable, say, an SBUS
device while trying to disable a PCI device.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

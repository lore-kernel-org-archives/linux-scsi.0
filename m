From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lsscsi is broken
Date: Sat, 10 May 2008 16:36:43 -0600
Message-ID: <20080510223643.GO19219@parisc-linux.org>
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com> <4825EAA0.5030305@torque.net> <86802c440805101306w64b5c72dn4dbfea74a6557c2f@mail.gmail.com> <20080510211904.GN19219@parisc-linux.org> <86802c440805101522l3cec5089he5d077fdee698cea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35348 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbYEJWhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 May 2008 18:37:00 -0400
Content-Disposition: inline
In-Reply-To: <86802c440805101522l3cec5089he5d077fdee698cea@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Sat, May 10, 2008 at 03:22:31PM -0700, Yinghai Lu wrote:
> will look at it monday or later.
> 
> don't want to keep on booting my laptop.
> 
> or my .config has some setting problem? it could be duplicated on all
> my test servers

Could be "# CONFIG_SYSFS_DEPRECATED is not set".  I have no idea what
that controls, but /sys/bus/scsi/devices could be one thing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

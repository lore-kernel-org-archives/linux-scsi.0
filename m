From: Christoph Hellwig <hch@infradead.org>
Subject: Re: proc_name in sysfs
Date: Mon, 11 Apr 2005 12:52:15 +0100
Message-ID: <20050411115215.GB13154@infradead.org>
References: <4253CA94.8000500@bull.net> <20050408064645.GA4860@infradead.org> <42563AC4.4050605@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:32918 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261788AbVDKLwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 07:52:21 -0400
Content-Disposition: inline
In-Reply-To: <42563AC4.4050605@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Frederic TEMPORELLI <frederic.temporelli@bull.net>, linux-scsi@vger.kernel.org

On Fri, Apr 08, 2005 at 06:03:16PM +1000, Douglas Gilbert wrote:
> >The real problem is that someone decided to export the proc_name in sysfs.
> >It's supposed to be only procfs-specific but someone violated that rule.
> 
> Forget the "proc_" part. It is effectively the lld_name.
> 
> Allowing the LLD to name itself to the scsi subsystem
> makes sense, especially when the LLD is made up of several
> kernel modules. See my previous example comparing the
> output of lsscsi -H and scan_host.sh .

In theory we have ->name for that, but people have decided to put really
verbose stuff in there.  A module name is important, not just for scsi.

James once had a proposal where the scsi_host can link to the module in
sysfs, which is the right thing and needed for other things like mkinitrd
aswell.

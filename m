From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [dm-devel] Proposal for annotating _unstable_ pages
Date: Fri, 22 May 2015 11:33:04 -0700
Message-ID: <20150522183304.GB27397@kmo-pixel>
References: <20150515205825.GC24967@birch.djwong.org>
 <20150519154200.GA2559@kmo-pixel>
 <20150519201055.GD27115@birch.djwong.org>
 <20150521010440.GA17405@kmo-pixel>
 <20150521165453.GK27863@quack.suse.cz>
 <20150521180954.GA27397@kmo-pixel>
 <20150521192112.GA2665@quack.suse.cz>
 <20150522181759.GB32090@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36316 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbbEVSez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 14:34:55 -0400
Content-Disposition: inline
In-Reply-To: <20150522181759.GB32090@birch.djwong.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, axboe@fb.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, zab@zabbo.net, linux-btrfs@vger.kernel.org

On Fri, May 22, 2015 at 11:17:59AM -0700, Darrick J. Wong wrote:
> Back when I was writing the stable pages patches, I observed that some of the
> filesystems didn't hold the pages containing their own metadata stable during
> writeback on a stable-writes device.  The journalling filesystems were fine
> because they had various means to take care of that.
> 
> ISTR ext2 and vfat were the biggest culprits, but both maintainers rejected
> the patches to fix that behavior.  This might no longer be the case; those
> patches were so long ago I can't find them in Google.

Not at all surprised. Yeah, this would solve that problem - we just annotate
those bios so we don't bounce them until we hit a point where we need to.

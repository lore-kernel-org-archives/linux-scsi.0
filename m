From: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Wed, 25 Jan 2012 11:29:32 +0800
Message-ID: <20120125032932.GA7150@localhost>
References: <20120124151504.GQ4387@shiny>
 <20120124165631.GA8941@infradead.org>
 <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
 <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
 <20120124184054.GA23227@infradead.org>
 <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48971 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2AYD3m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 22:29:42 -0500
Content-Disposition: inline
In-Reply-To: <20120124203936.GC20650@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

On Tue, Jan 24, 2012 at 09:39:36PM +0100, Jan Kara wrote:
> On Tue 24-01-12 15:13:40, Jeff Moyer wrote:
[snip]
> > > Maybe 128 KB is a too small default these days but OTOH noone prevents you
> > > from raising it (e.g. SLES uses 1 MB as a default).
> > 
> > For some reason, I thought it had been bumped to 512KB by default.  Must
> > be that overactive imagination I have...  Anyway, if all of the distros
> > start bumping the default, don't you think it's time to consider bumping
> > it upstream, too?  I thought there was a lot of work put into not being
> > too aggressive on readahead, so the downside of having a larger
> > read_ahead_kb setting was fairly small.
>   Yeah, I believe 512KB should be pretty safe these days except for
> embedded world. OTOH average desktop user doesn't really care so it's
> mostly servers with beefy storage that care... (note that I wrote we raised
> the read_ahead_kb for SLES but not for openSUSE or SLED (desktop enterprise
> distro)).

Maybe we don't need to care much about the embedded world when raising
the default readahead size? Because even the current 128KB is too much
for them, and I see Android setting the readahead size to 4KB...

Some time ago I posted a series for raising the default readahead size
to 512KB. But I'm open to use 1MB now (shall we vote on it?).

Thanks,
Fengguang

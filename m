From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 14:11:55 -0500
Message-ID: <x49zkdckj9g.fsf@segfault.boston.devel.redhat.com>
References: <4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz> <4F1BFF5F.6000502@panasas.com>
	<20120123161857.GC28526@quack.suse.cz>
	<20120123175353.GD30782@redhat.com>
	<x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
	<20120124151504.GQ4387@shiny> <20120124165631.GA8941@infradead.org>
	<186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
	<x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
	<20120124184054.GA23227@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2AXTMi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 14:12:38 -0500
In-Reply-To: <20120124184054.GA23227@infradead.org> (Christoph Hellwig's
	message of "Tue, 24 Jan 2012 13:40:54 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Chris Mason <chris.mason@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Darrick J.Wong" <djwong@us.ibm.com>

Christoph Hellwig <hch@infradead.org> writes:

> All three filesystems use the generic mpages code for reads, so they
> all get the same (bad) I/O patterns.  Looks like we need to fix this up
> ASAP.

Actually, in discussing this with Vivek, he mentioned that read ahead
might be involved.  Sure enough, after bumping read_ahead_kb, 1MB I/Os
are sent down to the storage (for xfs anyway).

Cheers,
Jeff

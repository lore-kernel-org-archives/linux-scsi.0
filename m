From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH-v2 0/9] target: Add support for EXTENDED_COPY (VAAI)
 offload emulation
Date: Mon, 26 Aug 2013 15:46:28 -0700
Message-ID: <20130826224628.GJ26818@lenny.home.zabbo.net>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3HZWqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 18:46:47 -0400
Content-Disposition: inline
In-Reply-To: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On Mon, Aug 26, 2013 at 10:02:59PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@daterainc.com>
> 
> Hi folks,
> 
> This -v2 series adds support to target-core for generic EXTENDED_COPY offload
> emulation as defined by SPC-4 using virtual (IBLOCK, FILEIO, RAMDISK)
> backends.

Cool, thanks for sending this out.  I'll just stare blankly but
supportively at the SCSI details.

I've been experimenting with the reasonable suggestion of using splice
as the entry point into the high level fs methods that'd be backed by
this stuff.  Let me get it cleaned up and sent out for review.

Hopefully with a few iterations of that we could test some block file
systems on top of this.

> This implemenation fully supports copy offload between the same device
> backend, and across multiple device backends.  It supports copy offload
> transparently across multiple target ports of different fabrics, eg:
> iSCSI -> FC, FC -> iSER, iSER -> FCoE and so on.

That's exciting!  I doubt that we want to be derailed by getting this
working in the first pass, but it'd be fun to enable cross-fs copying
once we got the fundamentals worked out

- z

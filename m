From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [LSF/MM TOPIC] update on discard support & testing with vendors
Date: Mon, 17 Jan 2011 17:37:34 -0700
Message-ID: <20110118003734.GE6262@parisc-linux.org>
References: <4D345637.6000207@redhat.com> <AANLkTikihfUrLF3mMtMqYFsxqDgeQE=bv-=MN-ToY6R6@mail.gmail.com> <yq18vyjdrsh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39612 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1ARAhg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 19:37:36 -0500
Content-Disposition: inline
In-Reply-To: <yq18vyjdrsh.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jan 17, 2011 at 06:38:54PM -0500, Martin K. Petersen wrote:
> Yeah, many vendors stick to reporting compliance with really old
> revisions to prevent legacy operating systems from blowing up.

That sounds like a heuristic ... :-)

> However, the SCSI folks are vehemently against having heuristics in the
> first place (guess how many USB-ATA bridge vendors actively participate
> in T10).

It's an odd situation where 99.9% of the marketshare don't participate
in the standards committee.

> T10's official policy is that the device can fail any command
> with any (valid) arguments at any time. And that the OS stack should
> always retry with less data, try a different command variant, etc. That
> might be another good topic for discussion, actually. Because while we
> do have some hacks in place (use_10, etc.) things will soon get more
> complex.

I'd love to live in their world where the device won't fall over and
refuse to respond to any further commands without a power cycle.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

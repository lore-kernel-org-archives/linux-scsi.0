From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [LSF/MM TOPIC] blk-trace update vs API stability
Date: Wed, 04 Jan 2017 12:17:34 -0500
Message-ID: <x49d1g2ycb5.fsf@segfault.boston.devel.redhat.com>
References: <62463a62-2dcb-639c-364c-3cc8b50628d2@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <62463a62-2dcb-639c-364c-3cc8b50628d2@suse.de> (Hannes Reinecke's
        message of "Wed, 4 Jan 2017 09:49:33 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke <hare@suse.de> writes:

> At LSF I'd like to discuss
> - Do we consider blktrace (and any other tracepoint in eg SCSI) as a
> stable API?

I don't have a strong opinion on this.

> - How do we go about modifying blktrace?

Blktrace has a version number associated with trace events.  Bump the
version for non-backward-compatible changes.

> - Is this even desired?

Yes.

Cheers,
Jeff

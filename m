From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Mon, 23 Jan 2012 13:28:08 -0500
Message-ID: <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz> <4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz> <4F1BFF5F.6000502@panasas.com>
	<20120123161857.GC28526@quack.suse.cz>
	<20120123175353.GD30782@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120123175353.GD30782@redhat.com> (Andrea Arcangeli's message
	of "Mon, 23 Jan 2012 18:53:53 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Andrea Arcangeli <aarcange@redhat.com> writes:

> On Mon, Jan 23, 2012 at 05:18:57PM +0100, Jan Kara wrote:
>> requst granularity. Sure, big requests will take longer to complete but
>> maximum request size is relatively low (512k by default) so writing maximum
>> sized request isn't that much slower than writing 4k. So it works OK in
>> practice.
>
> Totally unrelated to the writeback, but the merged big 512k requests
> actually adds up some measurable I/O scheduler latencies and they in
> turn slightly diminish the fairness that cfq could provide with
> smaller max request size. Probably even more measurable with SSDs (but
> then SSDs are even faster).

Are you speaking from experience?  If so, what workloads were negatively
affected by merging, and how did you measure that?

Cheers,
Jeff

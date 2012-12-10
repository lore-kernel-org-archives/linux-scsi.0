From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,v3,repost 00/10] make I/O path allocations more numa-friendly
Date: Mon, 10 Dec 2012 12:59:30 -0500
Message-ID: <x49zk1l6b5p.fsf@segfault.boston.devel.redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com> (Jeff
	Moyer's message of "Tue, 27 Nov 2012 11:46:28 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi,
>
> This patch set makes memory allocations for data structures used in
> the I/O path more numa friendly by allocating them from the same numa
> node as the storage device.  I've only converted a handful of drivers
> at this point.  My testing is limited by the hardware I have on hand.
> Using these patches, I was able to max out the bandwidth of the storage
> controller when issuing I/O from any node on my 4 node system.  Without
> the patch, I/O from nodes remote to the storage device would suffer a
> penalty ranging from 6-12%.  Given my relatively low-end setup[1], I
> wouldn't be surprised if others could show a more significant performance
> advantage.
>
> This is a repost of the last posting.  The only changes are additional
> reviewed-by/acked-by tags.  I think this version is ready for inclusion.
> James, would you mind taking a look?

James?  Do you have any objections to including this for 3.8?

-Jeff

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Improve block device testing coverage
Date: Thu, 30 Mar 2017 23:57:02 -0700
Message-ID: <20170331065702.GA17435@infradead.org>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Sender: fstests-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fstests@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 30, 2017 at 05:19:01PM +0400, Dmitry Monakhov wrote:
> During LSFMM we have discussed how to test lower-backend of linux IO-stack.
> Common opinion was that xfstests is the most obvious solution which cover
> most of use cases filesystem care about.
> 
> I'm working on integration T10-DIF/DIF data integrity features to ext4,
> for that reason we need to be shure that linux integrity framework is
> in working state, which is currently broken in several places.
> 
> In fact, it is relatively simple to add basic coverage tests for basic
> IO operations over virtual device with integrity support. All we need
> is to add lio target support.

First:  Thanks for adding block layer testing!

Second: even more so than Darrick's blockdev fallocate test this is
the wrong place.  If I run xfstests I want to test my file system,
not random block device features.  Please start a proper block device
testsuite instead, possibly by copy and pasting code from xfstests.

That's how I started the test suite for qemu's block layer for example.

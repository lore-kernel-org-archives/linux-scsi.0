From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] Make aborts work on tcm_qla2xxx, other cleanups
Date: Sat, 17 Nov 2012 13:40:45 -0800
Message-ID: <1353188445.21033.77.camel@haakon2.linux-iscsi.org>
References: <1353081979-29474-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353081979-29474-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-11-16 at 08:06 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Hi Nic,
> 
> Here's a series that makes aborts actually work on qla2xxx.  Stopping
> and releasing commands is quite convoluted so I'm not sure the first
> patch is totally correct, but without it I can easily reproduce task
> hangs or list corruption by having an initiator flood a tcm_qla2xxx
> target with aborts.  With those fixes, Steve's patch is pretty
> straightforward.
> 

The first patch looks safe enough a bugfix to queue for v3.7.0.  Applied
to target-pending/master, with CC' to stable.

Replying to the second patch inline..

> The last two patches are just cleanups I noticed while debugging this.
> 

Applying #3 + #4 to for-next, thanks.

> Just to be clear: to the extent that this is copyrightable work, it is
> released exclusively under the GPL.  No permission is granted to
> redistribute this under any other terms.
> 

The GPL license for these files w/ my authorship in mainline is
perfectly clear.   This extra legalese in cover-letters for a few lines
of code only serves to be annoying.

Please leave it off the target list in the future, Thanks.

--nab

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/19] qla2xxx: Enable SLER conditionally in target mode.
Date: Thu, 25 Sep 2014 03:14:20 -0700
Message-ID: <20140925101420.GA305@infradead.org>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
 <1411632612-7320-7-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411632612-7320-7-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 25, 2014 at 04:09:59AM -0400, Saurav Kashyap wrote:
> From: Arun Easi <arun.easi@qlogic.com>
> 
> Sequence level error recovery (aka FC Tape) is not really required
> for disk devices. On heavily loaded system, with slow turn around,
> a bunch of status enquiries using REC puts additional burden to the
> target, so just turn off SLER by default.

I don't think a new compile time flag for this is a good idea.  I can
put this in under the assumption that it will basically #if 0 out the
code, but a module or sysfs parameter would be more useful if your
intent is that users ever enable it.

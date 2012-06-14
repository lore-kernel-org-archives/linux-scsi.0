From: Tomas Carnecky <tomas.carnecky@gmail.com>
Subject: Re: drivers/block/cpqarray.c:938:2: error: too many arguments to
 function lk_rq_map_sg
Date: Thu, 14 Jun 2012 11:52:38 +0000
Message-ID: <1339674758-ner-4999@calvin>
References: <4fd91c3f.KAwMcygw9fFGn9Cx%wfg@linux.intel.com>
	<4FD984F3.3070502@kernel.dk> <20120614090151.GA12013@localhost>
	<4FD9A95D.40903@kernel.dk> <20120614100205.GA13217@localhost>
	<4FD9C0D2.20500@kernel.dk> <20120614113142.GA13954@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120614113142.GA13954@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Fengguang Wu <wfg@linux.intel.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, virtualization@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, "git@vger.kernel.org" <git@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 14 Jun 2012 19:31:42 +0800, Fengguang Wu <wfg@linux.intel.com> wrote:
> On Thu, Jun 14, 2012 at 12:45:38PM +0200, Jens Axboe wrote:
> > On 06/14/2012 12:02 PM, Fengguang Wu wrote:
> > > OK, I'll add a grep for "Dont-Auto-Build". If it's found in *any*
> > > commit of the branch, the build script will skip the whole branch.
> > > Does this make sense to you?
> > 
> > Yeah that'll work for me. A description or tag might be more elegant,
> > but this is easier...
> 
> Great, let's settle with the in-commit tag "Dont-Auto-Build" for now :)
> 
> "git branch --edit-description" could potentially be the most elegant
> solution, unfortunately for now there seems no way for me to retrieve
> the branch description edited by you..
> 
> Another alternative, git tag, has the problem that it goes out of sync
> every time you do rebase, which will sure happen a lot for early RFC
> patches.

Commit notes or a special namespace for branches (refs/heads/wip/...) would
also be an option.

tom

From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile error
Date: Wed, 1 Aug 2007 08:32:39 -0600
Message-ID: <20070801143239.GZ21219@parisc-linux.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg> <20070801135515.GV21219@parisc-linux.org> <46B09843.7010701@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49743 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbXHAOck (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 10:32:40 -0400
Content-Disposition: inline
In-Reply-To: <46B09843.7010701@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 01, 2007 at 04:27:15PM +0200, Gabriel C wrote:
> Matthew Wilcox wrote:
> > I'd be interested in seeing the results of the randconfig trials on the
> > driver with those 23 patches applied, but not particularly interested in
> > the intermediate result.
> 
> I can do that on weekend.

Thanks

> Are the patches meant for -mm or git head ?

They were developed against git head as of a few days ago.  Here's a git
tree, if that's easier for you:

http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=shortlog

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

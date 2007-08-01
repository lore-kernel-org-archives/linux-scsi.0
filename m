From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile
 error
Date: Wed, 01 Aug 2007 16:46:40 +0200
Message-ID: <46B09CD0.5050307@googlemail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg> <20070801135515.GV21219@parisc-linux.org> <46B09843.7010701@googlemail.com> <20070801143239.GZ21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:8803 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbXHAOrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 10:47:05 -0400
Received: by nf-out-0910.google.com with SMTP id g13so60685nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 07:47:03 -0700 (PDT)
In-Reply-To: <20070801143239.GZ21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Aug 01, 2007 at 04:27:15PM +0200, Gabriel C wrote:
>> Matthew Wilcox wrote:
>>> I'd be interested in seeing the results of the randconfig trials on the
>>> driver with those 23 patches applied, but not particularly interested in
>>> the intermediate result.
>> I can do that on weekend.
> 
> Thanks
> 
>> Are the patches meant for -mm or git head ?
> 
> They were developed against git head as of a few days ago.  Here's a git
> tree, if that's easier for you:
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=shortlog
> 

Ach nice , yes is a lot easier to work with git.

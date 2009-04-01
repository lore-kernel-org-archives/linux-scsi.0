From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCHSET block] block: blk-map updates and API cleanup
Date: Wed, 01 Apr 2009 23:08:30 +0900
Message-ID: <49D3755E.1090209@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:55406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbZDAOIm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 10:08:42 -0400
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Tejun Heo wrote:
> Hello, all.
> 
> These patches are available in the following git tree but it's on top
> of the previous blk-map-related-fixes patchset which needs some
> updating, so this posting is just for review and comments.  This
> patchset needs to spend quite some time in RCs even if it gets acked
> eventually, so definitely no .30 material.  Please also note that I
> haven't updated the comment about bio chaining violating queue limit,
> so please ignore that part.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-map
>  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=blk-map

Oops, forgot to cc linux-scsi.  Cc'ing linux-scsi and James.  The
thread is (gmane hasn't picked it up yet).

 http://lkml.org/lkml/2009/4/1/228

Thanks.

-- 
tejun

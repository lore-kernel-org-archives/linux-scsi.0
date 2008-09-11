From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] mptfc: do not return host busy in queuecommand
Date: Thu, 11 Sep 2008 11:46:54 -0500
Message-ID: <1221151614.3330.10.camel@localhost.localdomain>
References: <1220906519-17649-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38369 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbYIKQq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 12:46:58 -0400
In-Reply-To: <1220906519-17649-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>

On Mon, 2008-09-08 at 15:41 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This reverts
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-post-merge-2.6.git;a=commitdiff;h=d2dee934ea40e45135715d2d6ecc863af5620148
> 
> I goofed and meant to return SCSI_MLQUEUE_TARGET_BUSY but
> wrote SCSI_MLQUEUE_HOST_BUSY. And actually when we are starting
> up IO we do not want to reutrn either, because there will probably
> not be any IO in the queue and we will have to wait for
> the host/target_blocked counter to hit zero, before we can send IO.
> 
> This patch was made over scsi-post.

Since it's not upstream, and this tree will rebase, I just pulled the
original commit out.

James



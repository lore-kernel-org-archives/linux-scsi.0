From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 4/6] drivers/scsi/sg.c: convert to kstrtoul_from_user()
Date: Tue, 10 Jan 2012 16:12:27 -0800
Message-ID: <20120110161227.cc8449f2.akpm@linux-foundation.org>
References: <20120110234235.774BF200133@hpza10.eem.corp.google.com>
	<1326240524.3264.91.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2AKAM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 19:12:29 -0500
In-Reply-To: <1326240524.3264.91.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, sboyd@codeaurora.org, dgilbert@interlog.com, dougg@torque.net

On Tue, 10 Jan 2012 19:08:44 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2012-01-10 at 15:42 -0800, akpm@linux-foundation.org wrote:
> > From: Stephen Boyd <sboyd@codeaurora.org>
> > Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()
> > 
> > Instead of open coding this function use kstrtoul_from_user() directly.
> 
> I really don't like these invent post facto functions and then try to
> insert them on the grounds the original users are now "open coded".
> However, if doug acks (or sends it as part of an update), I'll apply.
> 

The main reason for adding helpers such as kstrtoul_from_user() is that
we have recognised that certain code patterns appear in multiple
places.  So we add the helper and then clean up the code sites which
inspired that addition.

This is good!  It's a part of our basic code maintenance.

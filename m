From: Tejun Heo <tj@kernel.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 17 Jul 2012 11:09:32 -0700
Message-ID: <20120717180932.GB2878@google.com>
References: <4FE454CA.6080007@matthiasprager.de>
 <4FFAED4F.3080100@matthiasprager.de>
 <4FFB32E5.1050109@farcaster.org>
 <4FFB7354.8040809@matthiasprager.de>
 <4FFB8A86.7000009@farcaster.org>
 <4FFCBA4C.4000502@farcaster.org>
 <4FFD6F3D.2030708@matthiasprager.de>
 <4FFD8410.7050604@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2GQSJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 14:09:37 -0400
Received: by pbbrp8 with SMTP id rp8so1149934pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 11:09:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FFD8410.7050604@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>

Hello,

On Wed, Jul 11, 2012 at 03:48:00PM +0200, Matthias Prager wrote:
> I just tested kernel version 3.4.4 without commit
> 85ef06d1d252f6a2e73b678591ab71caad4667bb and it also works fine (beware
> of commit 62d3c5439c534b0e6c653fc63e6d8c67be3a57b1 as it conflicts with
> reverting 85ef06d1d252f6a2e73b678591ab71caad4667bb).
> 
> I'm trying to understand why this commit leads to the issue of i/o
> failing on spun down drives, in hopes of being able to fix it. Meanwhile
> maybe Tejun Heo (author of the commit) or Jens Axboe (the committer) are
> able to shed some light on this (I've included them in the CC list).

Nothing rings a bell for me.  How does it fail?  The only thing it
change is when and which media check commands are issued.

Thanks.

-- 
tejun

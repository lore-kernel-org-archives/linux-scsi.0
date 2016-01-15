From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 14:40:18 -0500
Message-ID: <20160115194018.GL3520@mtj.duckdns.org>
References: <20160114214602.GC3520@mtj.duckdns.org>
 <1452872774.2356.5.camel@HansenPartnership.com>
 <1452873302.2356.9.camel@HansenPartnership.com>
 <56992361.7030606@interlog.com>
 <1452882934.2356.13.camel@HansenPartnership.com>
 <20160115184252.GJ3520@mtj.duckdns.org>
 <1452884956.2356.21.camel@HansenPartnership.com>
 <20160115192755.GK3520@mtj.duckdns.org>
 <1452886568.2356.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35872 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcAOTkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2016 14:40:21 -0500
Received: by mail-yk0-f177.google.com with SMTP id v14so460970378ykd.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2016 11:40:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1452886568.2356.23.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

On Fri, Jan 15, 2016 at 11:36:08AM -0800, James Bottomley wrote:
> That's the point we were making: it can't be rectified easily.  Simply
> counting non-good returns is easy.  Counting something that's closer to
> errors is hard because first we have to define what an "error" is (I
> could see queue full being not an error, but what about not ready or
> initializing command required?) and then implement and infrastructure
> to classify and count the returns, which means an awful lot of sense
> data parsing.

Yeap, no objection.  Leaving as-is fine.

-- 
tejun

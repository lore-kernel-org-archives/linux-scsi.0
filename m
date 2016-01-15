From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 14:27:55 -0500
Message-ID: <20160115192755.GK3520@mtj.duckdns.org>
References: <20160114214602.GC3520@mtj.duckdns.org>
 <1452872774.2356.5.camel@HansenPartnership.com>
 <1452873302.2356.9.camel@HansenPartnership.com>
 <56992361.7030606@interlog.com>
 <1452882934.2356.13.camel@HansenPartnership.com>
 <20160115184252.GJ3520@mtj.duckdns.org>
 <1452884956.2356.21.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:33560 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbcAOT14 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2016 14:27:56 -0500
Received: by mail-yk0-f180.google.com with SMTP id k129so531564546yke.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2016 11:27:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1452884956.2356.21.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

Hello, James.

On Fri, Jan 15, 2016 at 11:09:16AM -0800, James Bottomley wrote:
> If we want to change what is being counted, we have to change the
> definition, so what is the definition you want to see for counting
> errors? and what's the reason driving this change?

There isn't anything else to it than what I already wrote.  It goes up
for things which aren't failures making the counter essentially
useless.  It's confusing from userland as it's unintuitive that these
commands are wrapped in SCSI ATA passthrough commands which use sense
data for result reporting and doing equivalent operations on native
SCSI and ATA devices lead to different outcomes.  The counter as-is is
just useless for libata devices.  If it can be rectified easily,
great.  If not, it isn't anything critical.

Thanks.

-- 
tejun

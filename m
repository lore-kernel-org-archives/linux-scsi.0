From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3 ver2] iscsi bidi & varlen support
Date: Mon, 18 Feb 2008 11:22:08 -0600
Message-ID: <1203355328.3324.34.camel@localhost.localdomain>
References: <47A20E85.6040906@panasas.com>  <47B99F75.6030400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52363 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbYBRRWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 12:22:15 -0500
In-Reply-To: <47B99F75.6030400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com

On Mon, 2008-02-18 at 17:08 +0200, Boaz Harrosh wrote:
> But ... James? is
> there any chance these can go into scsi-rc-fixes for the 2.6.25
> kernel? The reason they are so late was mainly because of a fallout
> in the merge process and a bug that was introduced because of that,
> but they were intended to go together with bidi into 2.6.25. Also
> as an important client code to the bidi-api that is introduced in
> 2.6.25 kernel.

Well, I think you know the answer to that one under Linus' rules for non
merge window submission.  It's not a bug fix; we haven't even put it
into -mm for testing and it's a pretty invasive change.

James



From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] LIO Target Synchronization with
 sysfs [resend]
Date: Sat, 27 Feb 2016 13:54:52 -0800
Message-ID: <1456610092.1750.34.camel@haakon3.risingtidesystems.com>
References: <56D1CC7C.7050609@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44376 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992461AbcB0Vyz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2016 16:54:55 -0500
In-Reply-To: <56D1CC7C.7050609@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

On Sat, 2016-02-27 at 08:19 -0800, Lee Duncan wrote:
> [Apologies for the resend.]
> 
> I would like to attend LSF/MM this year. I would like to discuss
> problems I've had dealing with LIO targets and their inherent
> asynchronicity in sysfs. I believe that with judicious use of kernel
> events we can help user space handle target changes more cleanly.
> 

I assume you mean configfs, and not sysfs.  ;)

> As for other topics:
> 
> As one of the maintainers of LIO at SUSE, I'd dearly love to see our
> iSCSI targets merged.
> 

You're talking about Mike's (CC'ed) original target_core_rbd.c driver,
right..?

He's been working on porting the PR related changes to a generic
interface that can be consumed by multiple backend using
target_core_iblock.c.






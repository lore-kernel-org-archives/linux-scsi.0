From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/3 ver2] iscsi bidi & varlen support
Date: Mon, 18 Feb 2008 19:33:40 +0200
Message-ID: <47B9C174.8000200@panasas.com>
References: <47A20E85.6040906@panasas.com>  <47B99F75.6030400@panasas.com> <1203355328.3324.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25989 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751889AbYBRReY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 12:34:24 -0500
In-Reply-To: <1203355328.3324.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com

On Mon, Feb 18 2008 at 19:22 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-02-18 at 17:08 +0200, Boaz Harrosh wrote:
>> But ... James? is
>> there any chance these can go into scsi-rc-fixes for the 2.6.25
>> kernel? The reason they are so late was mainly because of a fallout
>> in the merge process and a bug that was introduced because of that,
>> but they were intended to go together with bidi into 2.6.25. Also
>> as an important client code to the bidi-api that is introduced in
>> 2.6.25 kernel.
> 
> Well, I think you know the answer to that one under Linus' rules for non
> merge window submission.  It's not a bug fix; we haven't even put it
> into -mm for testing and it's a pretty invasive change.
> 
> James
> 
> 

It was extensively tested by all iscsi people. It has the Sign-off-by
of the iscsi maintainer. They are not new patches.

But, yes you are right. I now remember the trouble we had with Linus
last time. So it's 2.6.26 then. :-( . People that need it for 2.6.25
will just get it off the git tree.

Boaz


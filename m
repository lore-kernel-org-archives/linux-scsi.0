From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 0/6] mpt fusion: Firmware Event implementation using
	seperate WorkQueue
Date: Mon, 6 Apr 2009 10:39:49 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4C9FB@inbmail01.lsi.com>
References: <20090403114626.GA17721@lsi.com>
 <1238791449.3359.91.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:56538 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZDFFKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 01:10:07 -0400
In-Reply-To: <1238791449.3359.91.camel@mulgrave.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,


[PATCH 4/6] mpt fusion: Deleted functions for SAS topology scan changes, Expander events, link status events added

It is patch [5/6]. Only numbering is incorrect.

Actually before doing any further changes I was waiting for some feedback, since I have chosen different approach to submit patches.

I have chosen to split one logical patch into two patches. One with all modification and newly added functions, and other with all functions which are not part of mpt fusion. This is just to give more readability to reviewer. If I combine both the patches then patch will not be easily readable.
Is this method really helping you? Or shall I merge those patches into one?



Thanks
Kashyap


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Saturday, April 04, 2009 2:14 AM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 0/6] mpt fusion: Firmware Event implementation using seperate WorkQueue

On Fri, 2009-04-03 at 17:16 +0530, Kashyap, Desai wrote:
> These patches are created on top of MPT fusion previous patch applied on
> date 26/02/2009 with subject line: "mpt fusion: config, Taskmgmt cmd,
> Internal cmd, Ioctl cmd changes"
> 
> Some patches are splited into two diffrent patches only for readability
> purpose for reviewer.
> 
> Consider below patches as one logical patch. There is no harm to send
> those patches as single patch, but to give more readability I have choosen
> to split.
> PATCH 2 and PATCH 3.
> PATCH 4 and PATCH 5.
> 
> PATCH 3 and PATCH 5 include only those function which are not part of MPT
> fusion.

What actually happened to patch 5?  It looks like you've got two patch
number 4's

[PATCH 4/6] mpt fusion: SAS topology scan changes,Expander events, link status events added
[PATCH 4/6] mpt fusion: Deleted functions for SAS topology scan changes,Expander events, link status events added

But the ordering doesn't look to matter at all, fortunately.

James



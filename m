From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6] mpt fusion: Firmware Event implementation using
	seperate WorkQueue
Date: Fri, 03 Apr 2009 20:44:09 +0000
Message-ID: <1238791449.3359.91.camel@mulgrave.int.hansenpartnership.com>
References: <20090403114626.GA17721@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40876 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937228AbZDCUoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 16:44:12 -0400
In-Reply-To: <20090403114626.GA17721@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

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



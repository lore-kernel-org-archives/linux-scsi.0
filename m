From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] ibmvscsi.c: remove max-sectors module parm
Date: Thu, 23 Dec 2004 14:57:15 -0600
Message-ID: <1103835435.5290.45.camel@mulgrave>
References: <20041221223645.GA2736@cs.umn.edu>
	 <1103828621.5290.42.camel@mulgrave>  <20041223200153.GA18386@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42715 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261290AbULWU6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 15:58:03 -0500
In-Reply-To: <20041223200153.GA18386@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-12-23 at 14:01 -0600, Dave C Boutcher wrote:
> The patches I submitted on Tuesday are incremental on top of the four
> patches from November 29th.  Let me know if you would like the
> November 29th patches re-sent.

Actually, just the limit size of I/O requests with the two patches
rolled together (or is there nothing left of this now?)

James



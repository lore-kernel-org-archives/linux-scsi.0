From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH as448] Fix reference to deallocated memory in sr.c
Date: Tue, 18 Jan 2005 07:10:34 -0800
Message-ID: <1106061034.5151.0.camel@mulgrave>
References: <Pine.LNX.4.44L0.0501180955020.1457-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26813 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261312AbVARPKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 10:10:43 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501180955020.1457-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-18 at 09:56 -0500, Alan Stern wrote:
> When I posted a patch last week to fix a reference to deallocated memory 
> in sd.c, I forgot to check whether the same problem exists in sr.c.  It 
> does, and here's the patch to fix it.

Yes, I already caught that in the scsi-rc-fixes-2.6 tree (although I
haven't synchronised it yet).

James



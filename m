From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH: (as33e) Fix removal of /proc/scsi/hostdir on hot-unplug
Date: Fri, 1 Aug 2003 13:03:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801200352.GA3868@beaverton.ibm.com>
References: <20030709144410.GA3544@beaverton.ibm.com> <Pine.LNX.4.44L0.0307311532050.8053-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:41671 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S270875AbTHAUZO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2003 16:25:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307311532050.8053-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> Mike:
> 
> I sent this patch to you some time ago, and now that 2.6.0 is coming maybe
> it's time to submit it again.

I have resent this patch out a couple of times also plus the addition of
reducing users of the present bit. The version of your patch I have is
slightly differnt on a few lines. I will resend that version I have back
out to the list as I have been testing the whole series. It does not
matter to me which one gets use, but we need to use one of them so that
we stop getting errors.

-andmike

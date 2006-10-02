From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport is blocked.
Date: Mon, 2 Oct 2006 16:05:31 -0700
Message-ID: <20061002230531.GB27360@us.ibm.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com> <20061002221424.GP16272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:12975 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S965507AbWJBXFd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 19:05:33 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k92N5WB0024884
	for <linux-scsi@vger.kernel.org>; Mon, 2 Oct 2006 19:05:32 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k92N5Wqh529188
	for <linux-scsi@vger.kernel.org>; Mon, 2 Oct 2006 17:05:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k92N5Vv8008652
	for <linux-scsi@vger.kernel.org>; Mon, 2 Oct 2006 17:05:32 -0600
Content-Disposition: inline
In-Reply-To: <20061002221424.GP16272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

Matthew Wilcox <matthew@wil.cx> wrote:
> On Mon, Oct 02, 2006 at 03:26:00PM -0400, James Smart wrote:
> > - Fix the error handler. (but we all know this is a lot of work,
> >     of which none of us have the time to do, nor expect it to
> >     be complete in time for our next distro delivery).
> 
> Can't you fix this in the driver instead?  Seems to me that
> .eh_timed_out in the SHT would be enough to fix this case.  Just keep
> returning EH_RESET_TIMER until the condition expires.

This is already done in fc_timed_out.

-andmike
--
Michael Anderson
andmike@us.ibm.com

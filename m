From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 10:43:01 -0700
Message-ID: <20050621174301.GA726@us.ibm.com>
References: <1118930260.4998.6.camel@mulgrave> <Pine.LNX.4.44L0.0506181554270.3347-100000@netrider.rowland.org> <20050621171209.GB29396@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:26526 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262158AbVFURnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 13:43:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5LHh9Bu017680
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 13:43:09 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5LHh8W1195248
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 13:43:08 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5LHh8ep008985
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 13:43:08 -0400
Content-Disposition: inline
In-Reply-To: <20050621171209.GB29396@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Jun 21, 2005 at 10:12:09AM -0700, Mike Anderson wrote:
> Alan Stern [stern@rowland.harvard.edu] wrote:
> > James and Mike:
> > 
> > Here's my patch (as529), very lightly tested.  Among the changes:
> > 
> 
> I ran the updated version of your patch on a scsi-misc-2.6 kernel with an
> Emulex and Qlogic adapter. It does not find any devices of these adapters
> during scan. I need to look into this.

Mike -

You probably need Alan's most recent patch that passes through
scsi_scan_target's parent argument.

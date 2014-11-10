From: Andras Kovacs <akovacs@fixstars.com>
Subject: Re: UNMAP command parameter list
Date: Mon, 10 Nov 2014 15:56:11 +0000 (UTC)
Message-ID: <loom.20141110T164410-58@post.gmane.org>
References: <loom.20141108T001847-741@post.gmane.org> <94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net> <loom.20141108T211736-836@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaKJP4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 10:56:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XnrKa-0004IK-QZ
	for linux-scsi@vger.kernel.org; Mon, 10 Nov 2014 16:56:41 +0100
Received: from S0106602ad06f2965.gv.shawcable.net ([24.68.136.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2014 16:56:40 +0100
Received: from akovacs by S0106602ad06f2965.gv.shawcable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2014 16:56:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andras Kovacs <akovacs <at> fixstars.com> writes:

> 
> Elliott, Robert (Server Storage <Elliott <at> hp.com> writes:
> 
> > That is the data transferred for the command, not in the
> > command descriptor block itself.
> 
> Thank you. Then I guess I'll find the Paramerer List in the struct
> scsi_data_buffer sdb variable (within struct scsi_cmnd). Will check on 
> Monday.

  I've looked into it, but struct scsi_data_buffer doesn't contain a byte
array (rather a struct sg_table variable and some housekeeping vars). So my
question is still: where can I find the Parameter List associated with a
particular UNMAP command?



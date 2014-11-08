From: Andras Kovacs <akovacs@fixstars.com>
Subject: Re: UNMAP command parameter list
Date: Sat, 8 Nov 2014 20:22:23 +0000 (UTC)
Message-ID: <loom.20141108T211736-836@post.gmane.org>
References: <loom.20141108T001847-741@post.gmane.org> <94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaKHUWh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2014 15:22:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XnCWp-0000dP-CH
	for linux-scsi@vger.kernel.org; Sat, 08 Nov 2014 21:22:35 +0100
Received: from 24.68.143.161 ([24.68.143.161])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 08 Nov 2014 21:22:35 +0100
Received: from akovacs by 24.68.143.161 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 08 Nov 2014 21:22:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Elliott, Robert (Server Storage <Elliott <at> hp.com> writes:

> That is the data transferred for the command, not in the
> command descriptor block itself.

Thank you. Then I guess I'll find the Paramerer List in the struct
scsi_data_buffer sdb variable (within struct scsi_cmnd). Will check on Monday.



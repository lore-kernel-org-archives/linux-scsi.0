From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi scan bug when peripheral qualifier of 3 is returned
Date: Wed, 4 Jan 2006 09:40:19 -0800
Message-ID: <20060104174019.GA3995@us.ibm.com>
References: <43BB750A.5050000@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53223 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S965246AbWADRkW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2006 12:40:22 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k04HeMcq015424
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 12:40:22 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k04HgK0S175582
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 10:42:20 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k04HeLU5021675
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 10:40:21 -0700
Content-Disposition: inline
In-Reply-To: <43BB750A.5050000@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jan 04, 2006 at 01:11:06AM -0600, Mike Christie wrote:

> But for SCSI_SCAN_TARGET_PRESENT bflags is not set. Is the correct fix 
> to move where bflagsp gets set in scsi_probe_and_add_lun so that it gets 
> set for the SCSI_SCAN_TARGET_PRESENT case, or should __scsi_scan_target 
> be passing scsi_sequential_lun_scan and possibly scsi_report_lun_scan 
> some default bflags values?

It looks OK to me as-is, since bflags is also passed to and set in
scsi_probe_lun(), right?

-- Patrick Mansfield

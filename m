From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 10:31:23 -0700
Message-ID: <20060428173122.GA18383@us.ibm.com>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com> <44524DF6.3000509@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:6031 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751430AbWD1RbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:31:25 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3SHVOwX009416
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 13:31:24 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3SHVOvY247350
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 11:31:24 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k3SHVOYG004316
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 11:31:24 -0600
Content-Disposition: inline
In-Reply-To: <44524DF6.3000509@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert <dougg@torque.net> wrote:
> > 1. Hotplug is still a bit of a mess
> > 2. SATA attachment doesn't work
> 
> 3. my whole SCSI subsystem locked up a couple of times.
> 
> If that is still a problem then I would recommend other
> testers place their root file system on a PATA disk :-)

Can you provide information on your configuration? Is there anything in
the logs prior to the lock up?

-andmike
--
Michael Anderson
andmike@us.ibm.com

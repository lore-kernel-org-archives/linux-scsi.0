From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: 19 Jan 2004 12:06:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074531999.1895.20.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0598E3F@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:16870 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265392AbUASRG4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:06:56 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E3F@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "Michael W. Shaffer" <mwshaffer@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-01-19 at 11:55, Andrew Vasquez wrote:
> The problem is during the removal of the failover and IOCTL code
> from the scsi-qla2xxx-2.6 tree, one critical piece of code
> (a one-liner) was inadvertently removed that effectively disables
> the drivers ability to bind fcports (devices found in the loop
> or fabric) to the SCSI nexus (h/b/t/l).

OK, my fault, I'm sorry.  I actually only have a single qla2340 and no
attached storage, so I wasn't able to see the problem when I did the
driver code editing.  I'll push the patch ASAP.

James



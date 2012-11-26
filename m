From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED OPERATION CODES
Date: Mon, 26 Nov 2012 18:50:33 -0500
Message-ID: <yq18v9nsz3q.fsf@sermon.lab.mkp.net>
References: <20121125184525.0b7967c4@stein>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24791 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab2KZXus (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 18:50:48 -0500
In-Reply-To: <20121125184525.0b7967c4@stein> (Stefan Richter's message of
	"Sun, 25 Nov 2012 18:45:25 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan,

Stefan> I did not try "sg_write_same" on any of the devices; but since
Stefan> the two SPC-3 devices are correctly identified as "fully
Stefan> provisioned", won't issue WRITE SAME to them either.

What if you have an SSD behind one of them?


Stefan> Hence let's remove the no_report_opcodes and no_write_same
Stefan> blacklist flags so that these commands can be used on
Stefan> respectively capable targets.

I just erred on the side of caution. If you are happy without belt and
suspenders that's perfectly ok with me :)

-- 
Martin K. Petersen	Oracle Linux Engineering

From: Luben Tuikov <luben@splentec.com>
Subject: Q: scsi device driver and status byte as per SAM2?
Date: Fri, 24 May 2002 13:38:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CEE7AA7.AC7E1A51@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g4OGbqu16235
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2002 12:37:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

As far as I can see from the sources, 
scsi device drivers don't set status byte returned
from the device server (SCSI device).

Is this true?

They only set the host_byte in the SCpnt->result.

My module sits between the low-level scsi device driver
and the mid-level. Is there a way I can get the
status byte as per SAM2?

-- 
Luben

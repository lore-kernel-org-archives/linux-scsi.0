From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/9] mpt2sas : Discription patch
Date: Fri, 7 Aug 2009 19:31:47 +0530
Message-ID: <20090807140147.GA5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:46532 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbZHGOW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:22:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver bug fixes. Please consider it for 2.6.31.

All these patches are recreated after James B suggestion.
This patch set is bug fix and required to port back to stable kernel.


[PATCH 1/9] mpt2sas: Introduced check for enclosure_handle to avoid crash 
[PATCH 2/9] mpt2sas: Expander Add oops saying "Already part of another port"
[PATCH 3/9] mpt2sas: Raid 10 Value is showing as Raid 1E in /va/log/messages
[PATCH 4/9] mpt2sas: Config request and diag reset deadlock
[PATCH 5/9] mpt2sas: Excessive log info causes sas iounit page time out
[PATCH 6/9] mpt2sas: Remove loop inside config request

[PATCH 7/9] mpt2sas: crash due to Watchdog is active while OS in standby mode
[PATCH 8/9] mpt2sas: pdev drv data points to NULL while OS resume from
		hibernate mode.
[PATCH 9/9] mpt2sas: Bump driver version 01.100.04.00
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/6] mptsas : Discription patch
Date: Wed, 2 Sep 2009 11:42:22 +0530
Message-ID: <20090902061212.GA20211@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:51233 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZIBGes (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 02:34:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Discription patch
Patches are based on 2.6.31-rc8.
Patch 1,2 and 3 needs to go into stable kernel also.
Please consider this patch set for next kernel update.

[PATCH 1/6] mptsas : Sanity check for phyinfo is added.
[PATCH 2/6] mptsas : NULL pointer on big endian systems causing Expander
		     not to tear off
[PATCH 3/6] mptsas : PAE Kernel more than 4 GB kernel panic
[PATCH 4/6] mptsas : Send DID_NO_CONNECT for pending IOs of removed dev
[PATCH 5/6] mptsas : FW event thread and scsi mid layer deadlock in
		     SYNCHRONIZE CACHE command
[PATCH 6/6] mptsas : Bump version to 3.04.12

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

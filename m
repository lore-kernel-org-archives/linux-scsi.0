From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/11] mpt2sas: Discription patch
Date: Wed, 5 Aug 2009 11:01:07 +0530
Message-ID: <20090805053107.GA13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:42160 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902AbZHEFwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 01:52:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver bug fixes. Please consider it for 2.6.32.

"Previous Power cycling cascaded expanders causes kernel panic patch "
is divided into small sub patches considering James comment.

Patch 1/11 is kernel panic fix and required to port back to stable kernel.

[PATCH 1/11] mpt2sas: Power cycling cascaded expanders causes kernel panic
[PATCH 2/11] mpt2sas: Host Reset code cleanup 
[PATCH 3/11] mpt2sas: Return immediately if host is under recovery.
[PATCH 4/11] mpt2sas: Code cleanup for _scsih_link_change function
[PATCH 5/11] mpt2sas: Attempt only 2 config_request retry.
[PATCH 6/11] mpt2sas: Added proper error handling for _scsih_expander_add.

[PATCH 7/11] mpt2sas: Raid 10 Value is showing as Raid 1E in /va/log/messages
[PATCH 8/11] mpt2sas: When activating a inactive volume, hidden raid
		     components disapper.
[PATCH 9/11] mpt2sas: During Full port cable breaks get sas iounit config
		     page0 timeout
[PATCH 10/11] mpt2sas: OS is not going into standby mode.
[PATCH 11/11] mpt2sas: Bump driver version 01.100.06.00
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

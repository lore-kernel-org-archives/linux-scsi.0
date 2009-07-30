From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/6] mpt2sas: Discription patch
Date: Thu, 30 Jul 2009 18:20:09 +0530
Message-ID: <20090730124952.GA20582@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:49500 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZG3NK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2009 09:10:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver bug fixes. Please consider it for 2.6.32.

[PATCH 1/6] mpt2sas: Power cycling cascaded expanders causes kernel panic
[PATCH 2/6] mpt2sas: Raid 10 Value is showing as Raid 1E in /va/log/messages
[PATCH 3/6] mpt2sas: When activating a inactive volume, hidden raid
		     components disapper.
[PATCH 4/6] mpt2sas: During Full port cable breaks get sas iounit config
		     page0 timeout
[PATCH 5/6] mpt2sas: OS is not going into hibernation mode.
[PATCH 6/6] mpt2sas: Bump driver version 01.100.07.00
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

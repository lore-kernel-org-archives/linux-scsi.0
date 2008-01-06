From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH  0/33][SCSI] Arrange for removal of 'scsi_typedefs.h'
Date: Sun, 6 Jan 2008 04:02:50 +0100 (MET)
Message-ID: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53840 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYAFDDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:03:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Hi all

drivers/scsi/scsi_typedefs.h is about ready to be removed, only the
'struct scsi_cmnd' typedef Scsi_Cmnd is left.
This set converts all the Scsi_Cmnd's, except in:
Changelogs
Documentation/scsi/scsi_mid_low_api.txt

So if all these gets merged, in one form or the other, we can:
un'include scsi_typedefs.h from drivers/scsi/scsi.h
fix the text in Documentation/scsi/scsi_mid_low_api.txt
(finally) remove the file in question


Left the "over 80 characters wide"-warnings alone, until requested otherwise.

Am not subscribed on linux-scsi@vger.kernel.org, so if replying, please Cc: me.

Yours,
Richard Knutsson

PS
If someone know of a tool to chain-mail patches and still be able to customize
the mail-addresses between them, please let me know.

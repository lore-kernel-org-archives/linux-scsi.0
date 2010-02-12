From: Oliver Neukum <oliver@neukum.org>
Subject: question on detecting a media change
Date: Fri, 12 Feb 2010 23:01:31 +0100
Message-ID: <201002122301.31366.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:40279 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0BLWBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 17:01:36 -0500
Received: from vanamonde.localnet (p549A19BE.dip0.t-ipconnect.de [84.154.25.190])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: neukum_org@smtp-out003.kontent.com)
	by smtp-out003.kontent.com (Postfix) with ESMTPSA id 5575A400035E
	for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2010 23:01:34 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

how can I find out a medium has been actually changed?
I find ASC 0x28 ASCQ 0x00 NOT READY TO READY CHANGE, MEDIUM MAY HAVE CHANGED
in the tables but my card reader emits this when it wakes up from runtime
suspension. How do you find out whether the medium has actually been
changed?

	Regards
		Oliver

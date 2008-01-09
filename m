From: Oliver Neukum <oliver@neukum.org>
Subject: question on sd_open()
Date: Wed, 9 Jan 2008 21:55:15 +0100
Message-ID: <200801092155.16112.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:57983 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYAIUyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 15:54:43 -0500
Received: from [192.168.234.33] (p549A081F.dip0.t-ipconnect.de [84.154.8.31])
	by smtp-out.kontent.com (Postfix) with ESMTP id A77815806278
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jan 2008 21:54:41 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Hello,

is there a way to distinguish calls to sd_open() from mount() from
calls to open() ?

	Regards
		Oliver

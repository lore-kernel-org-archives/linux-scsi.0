From: Oliver Neukum <oliver@neukum.org>
Subject: question on sd_prep_fn()
Date: Mon, 16 Jan 2012 14:25:28 +0100
Message-ID: <201201161425.28952.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:53396 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2APNaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 08:30:00 -0500
Received: from vanamonde.suse.de (p4FFB1E93.dip.t-dialin.net [79.251.30.147])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: neukum_org@smtp-out002.kontent.com)
	by smtp-out002.kontent.com (Postfix) with ESMTPSA id 08CEA1003724A
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2012 14:23:41 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

could someone explain to me in which context sd_prep_fn() is called?

	TIA
		Oliver

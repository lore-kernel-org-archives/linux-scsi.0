From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 10:34:07 -0400
Message-ID: <20060911143406.GA12991@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:40327 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751247AbWIKOeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 10:34:12 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 246C41C24E8A
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 10:34:07 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id k8BEY7m7013284
	for linux-scsi@vger.kernel.org; Mon, 11 Sep 2006 10:34:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


A long-term, low priority project of mine is to increasingly isolate
HCIL addressing, making it easier to directly support FC/SAS-style
addressing without hacks and HCIL emulation.

The following two patches are a small part of the changes I've been
carrying for a while, in the repo
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/scsilun-2.6.git

Branches of note:

master		- vanilla linus
submit1		- patch #1; child of master
submit2		- patch #2; child of submit1
hacking		- the rest of the changes; child of submit2

THESE CHANGES ARE NOT [YET] FOR APPLICATION.  DO NOT APPLY.


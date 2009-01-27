From: Olaf Hering <olh@suse.de>
Subject: scsi_host_template.proc_name for ibmvscsic
Date: Tue, 27 Jan 2009 15:11:07 +0100
Message-ID: <20090127141107.GA15401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:35205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZA0OLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 09:11:09 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 1738444BC4
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2009 15:11:08 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


/sys/class/scsi_host/host0/proc_name should map to the drivers module
name according to Documentation/scsi/scsi_mid_low_api.txt

But this is not the case for drivers/scsi/ibmvscsi/ibmvscsi.c,
drivers/scsi/a100u2w.c, drivers/scsi/a2091.c and others.

Is it safe to fix at least ibmvscsi.c to have ibmvscsic as ->proc_name?

Olaf

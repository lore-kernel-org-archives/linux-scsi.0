From: Lee Duncan <lduncan@suse.com>
Subject: [LSF/MM TOPIC ATTEND] kernel booting using remote storage is a mess
Date: Tue, 3 Jan 2017 15:44:48 -0800
Message-ID: <ee864cdd-11c3-63d6-51b7-b23b984fdbc6@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60915 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964901AbdACXsO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Jan 2017 18:48:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

The process of booting a Linux kernel with remote storage (such as iSCSI
or FCoE) seems unnecessarily complicated if end users can even figure
out how to do it. This is of course exacerbated by the fact that every
company seems to CNA cards differently despite the iBFT standard.

If you add DM-Multipath on top of that, most bets are off on your
chances of getting it to reliably work.

I'd like to discuss how we can get this to work in a general way given
the world of systemd that we live in now.
-- 
Lee Duncan
SUSE Labs

From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/5] megaraid_sas: Updates for scsi-misc
Date: Mon, 10 Mar 2014 02:51:16 -0700
Message-ID: <CAHtARFHcaLNbNFrGYRU9SQpJzhhESM0=TVZ5X2Rz_=1fLvk_rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:47214 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaCJJvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 05:51:17 -0400
Received: by mail-yh0-f47.google.com with SMTP id 29so1081564yhl.20
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 02:51:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to
v06.803.01.00-rc1:

1. Load correct raid context timeout value for multipathing and clustering.
2. Fix megasas_ioc_init_fusion to use local stack variable.
3. Return leaked MPT frames to MPT command pool.
4. Add Dell PowerEdge VRTX SR-IOV VF device support.
5. Version and Changelog update.

This patch series apples on top of Sumit Saxena's latest patch series, which
starts here:

http://marc.info/?l=linux-scsi&m=139220849616649&w=2

and includes a small repost here:

http://marc.info/?l=linux-scsi&m=139374736120535&w=2

-Adam

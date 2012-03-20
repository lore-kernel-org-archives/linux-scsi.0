From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/3] megaraid_sas: Updates for scsi-misc
Date: Mon, 19 Mar 2012 19:49:42 -0700
Message-ID: <CAHtARFG7-OjUOtg6MvVy_7T_p5dN0U7ZFz+fwbbrOqBOB45_zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48389 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab2CTCto (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 22:49:44 -0400
Received: by wibhq7 with SMTP id hq7so4616420wib.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 19:49:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to v6.15-rc1:

1. Optimize HostMSIxVectors setting.
2. Add fpRead/WriteCapable, fpRead/WriteAcrossStripe checks.
3. Version and Changelog update.

-Adam

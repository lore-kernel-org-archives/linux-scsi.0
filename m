From: Jean Sacren <sakiwit@gmail.com>
Subject: [PATCH 0/1] scsi: Fix warning: zero-length gnu_printf format string
Date: Wed, 25 Aug 2010 17:55:29 -0600
Message-ID: <20100825235529.GA7152@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61693 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0HYXz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2010 19:55:27 -0400
Received: by pxi10 with SMTP id 10so409546pxi.19
        for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2010 16:55:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

Jean Sacren (1):
  scsi: Fix warning: zero-length gnu_printf format string

 drivers/scsi/constants.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


-- 
Jean Sacren
Bring LAMP To People

From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/4] megaraid_sas: Updates for scsi for-next
Date: Thu, 19 Jun 2014 17:31:21 -0700
Message-ID: <CAHtARFHX=RaJ3nnNc5VztZ_pE8mFqp1SMxujE55WV94mhcDiLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:46664 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaFTAbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 20:31:22 -0400
Received: by mail-yh0-f51.google.com with SMTP id f10so2311889yha.38
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 17:31:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to
v06.803.02.00-rc1.

1. Fix reset_mutex leak in megasas_reset_fusion().
2. Remove unused variables in megasas_instance.
3. Fix LD/VF affiliation parsing.
4. Version and Changelog update.

-Adam

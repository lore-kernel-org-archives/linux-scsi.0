From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/3] megaraid_sas: Updates for scsi-misc
Date: Sat, 9 Feb 2013 15:29:09 -0800
Message-ID: <CAHtARFHuGRpSAavTBfaYASX7-f9XkN4nW+dP0YvQ7ukhzB8g2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:51358 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3BIX3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2013 18:29:10 -0500
Received: by mail-qc0-f175.google.com with SMTP id j3so1853224qcs.34
        for <linux-scsi@vger.kernel.org>; Sat, 09 Feb 2013 15:29:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

James/linux-scsi,

The following small patch series for megaraid_sas brings the driver up
to v06.506.00.00-rc1:

1. Add 4k FastPath DIF support.
2. Dont load DevHandle unless FastPath enabled.
3. Version and Changelog update.

-Adam

From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 11:52:53 +0530
Message-ID: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:57658 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbZHRGXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 02:23:07 -0400
Received: by pxi34 with SMTP id 34so1618344pxi.4
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2009 23:23:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I have seen that SCSI supports bi-directional commands
DMA_BIDIRECTIONAL. However, I did not get such type of commands in my
mass storage driver. My device supports bi-directional data transfers.
My question is, how can I get such type of requests to my mass storage
driver? If so, how can I handle the IN and OUT buffers? Are there
separate buffers for both? Is there any support for the bi-directional
in the current SCSI implementation? I am currently using the 2.6.28
kernel code.

We have only one pointer for data buffer instead of two, one for data
OUT and one for data IN in command block. There is only one length
variable. How can we use the OUT and IN buffers? How can I pass
different IN length and OUT length to lower stack from SCSI layer?

Is there any thing need to be changed in the SCSI layer code to handle
the bi-directional data transfers?

Please point to me some links which shows the bi-directional data transfers.

Thanks in advance.

With Regards,
Madhavi M.

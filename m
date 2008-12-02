From: "Sihan Goi" <goister@gmail.com>
Subject: Linux SCSI programming
Date: Tue, 2 Dec 2008 09:50:00 +0800
Message-ID: <b7bb26000812011750y23072ber44750687321c0eb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:52454 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYLBBuC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 20:50:02 -0500
Received: by ti-out-0910.google.com with SMTP id b6so1744011tic.23
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2008 17:50:01 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm trying to port a Windows SCSI API over to Linux. The API has
several functions, most of them using ATA_PASS_THROUGH_EX to send a
vendor specific command over to the device. I've managed to port 1 of
the API function that is a modified INQUIRY command. However, I'm very
confused as to how ATA passthrough is done in Linux. I've looked at
the sg3_utils source code to get some inspiration but it's too
complicated for me to understand what's going on.

Does anyone know how to port this?

In Windows a ATA_PASS_THROUGH_EX pointer is declared and memory
allocated for it. It's fields are then initialized(Length, AtaFlags,
DataTransferLength, TimeOutValue, DataBufferOffset, CurrentTaskFile[],
PreviousTaskFile[], etc) and then a DeviceIoControl() is called.

Now I know Linux's version of DeviceIoControl is ioctl() and I've used
it successfully for the INQUIRY command, but what's Linux's version of
ATA_PASS_THROUGH_EX?

Any help would be appreciated. Thanks!

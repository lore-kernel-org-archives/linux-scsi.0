From: loody <miloody@gmail.com>
Subject: dummy scsi read or scsi command periodically for external USB Hard Disk
Date: Sun, 6 Jul 2014 01:18:03 +0800
Message-ID: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63639 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaGERSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jul 2014 13:18:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

hi all:
    we met a USB Hard Disk that will go to suspend if host stop
sending scsi command over 5mins.
    To save the IO, kernel will keep the file in page cache as much as
he can and under this circumstances, the scsi command may disappear
for a while longer enough to cause the device suspend.

    is there any kernel config or module parameter can do the dummy
read or scsi command periodically?

appreciate your help in advance,

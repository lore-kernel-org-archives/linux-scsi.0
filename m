From: Ramya Desai <ramya.desai@gmail.com>
Subject: Return of PENDING status to SCSI driver
Date: Fri, 12 Jun 2009 14:59:04 +0530
Message-ID: <3e7aae30906120229p3bbeb7f0jd07c5f1e823a456a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:2216 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZFLJ3C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 05:29:02 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1357744qwd.37
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 02:29:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear Experts,

I am writing my mass storage class driver for my custom USB device.
My device is capable of queuing the commands that are issued to it.
So, I wanted to send the second command from my driver even before the
completion of first command.
To do this I wanted to return the PENDING status to the SCSI layer
immediately after receiving the command.

Can I do as explained above? I studied the default MS class driver, in
which no PENDING status was available.

Thanks in advance,

Regards,
RD

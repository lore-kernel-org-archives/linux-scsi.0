From: Vivek Mahajan <vmahajan@gmail.com>
Subject: scsi_unregister_driver in 2.6.10
Date: Mon, 10 Jan 2005 17:57:32 -0700
Message-ID: <e20f392505011016575aac92a1@mail.gmail.com>
Reply-To: Vivek Mahajan <vmahajan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.201]:32095 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262716AbVAKA5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 19:57:37 -0500
Received: by wproxy.gmail.com with SMTP id 67so117837wri
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 16:57:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was working on my SCSI module and tried to use
scsi_unregister_driver(). But looks like it has been made GPL only. I
get unresolved symbol : driver_unregister(), when I tried to load the
module. I think it is #defined to driver_unregister() in
include/scsi/scsi_driver.h. And driver_unregister is exported as GPL
only.

At the same time, scsi_register_driver() works with non GPL code
without any problem. As this call is exclusively defined in
drivers/scsi/scsi_sysfs.c.

I was just wondering wss it unintentional Or there was a purpose
behind that to make scsi_register_driver( ) as non GPL and
scsi_unregister_driver( ) as GPL only.

Any help in this matter will be highly appreciated.

Regards,
Vivek

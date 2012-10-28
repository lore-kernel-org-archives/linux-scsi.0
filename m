From: Shlomo Pongratz <shlomop@mellanox.com>
Subject: spin_lock in scsi_request_fn
Date: Sun, 28 Oct 2012 18:17:34 +0200
Message-ID: <508D5A9E.9040109@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43718 "HELO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753086Ab2J1QRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Oct 2012 12:17:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: ogerlitz@mellanox.com

Hi,

I've noticed a strange usage of spin lock in  scsi_request_fn located in 
drivers/scsi/scsi_lib.c
That is in line 1565 we have spin_lock(shost->host_lock);
but in line 1595 we have spin_unlock_irq(shost->host_lock);
Is this by design or it is a typo?

Best regards,
Shlomo Pongratz.

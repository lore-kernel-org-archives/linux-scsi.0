From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Best driver for qlogic 2200 fc?
Date: Mon, 17 Nov 2003 17:11:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311171711.36441.mgiammarco@virgilio.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp12.tin.it ([212.216.176.206]:41891 "EHLO vsmtp12.tin.it")
	by vger.kernel.org with ESMTP id S263334AbTKQQLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 11:11:39 -0500
Received: from cala (62.211.165.107) by vsmtp12.tin.it (7.0.019)
        id 3F8C849200E5116C for linux-scsi@vger.kernel.org; Mon, 17 Nov 2003 17:11:37 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
I have a lsi logic fusion mpt controller which is well supported under linux 
kernel.

Unfortunately it gives me slow performance (sequential read of 30mb/sec on a 
seagate 318452fc that can do 60mb/sec sequential read).

I would like to try qlogic 2200 hba, but I need a driver for linux that:

1) compiles statically on the kernel
2) works with scsi hard disks and as tcp/ip (fc0)

Can you give me some suggestions?

Thanks in advance.

-- 
Mario Giammarco


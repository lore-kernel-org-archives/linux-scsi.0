From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 11:12:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071483139.1433.3.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp2.tin.it ([212.216.176.222]:44268 "EHLO vsmtp2.tin.it")
	by vger.kernel.org with ESMTP id S263491AbTLOKM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 05:12:27 -0500
Received: from [213.45.38.89] (213.45.38.89) by vsmtp2.tin.it (7.0.019)
        id 3FD8B6A300238ABA for linux-scsi@vger.kernel.org; Mon, 15 Dec 2003 11:12:26 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
I now have a qlogic 2200 card and I am trying tcp/ip support:

- standard qlogicfc built in kernel seems to not support ip (I heard
there is a patch somewhere, is it right?)

- qla drivers 6.00 of qlogic website should support it but I am not able
to compile them with IP=1 option (I have tried on kernels 2.4.22 2.4.23)

- qla drivers 8.00 on sourceforge seems to not support it (and they
works only on 2.6.0 kernel).

Now I am stuck please help me I need them badly.

Thanks in advance for any help.
-- 
Mario Giammarco



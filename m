From: Russ Garrett <russ@garrett.co.uk>
Subject: Megaraid problems with >8GB RAM
Date: Tue, 26 Jul 2005 23:01:09 +0100
Message-ID: <42E6B2A5.9070903@garrett.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta09-winn.ispmail.ntl.com ([81.103.221.49]:35439 "EHLO
	mta09-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S262147AbVGZWAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 18:00:52 -0400
Received: from aamta11-winn.ispmail.ntl.com ([81.103.221.35])
          by mta09-winn.ispmail.ntl.com with ESMTP
          id <20050726220049.UNR16172.mta09-winn.ispmail.ntl.com@aamta11-winn.ispmail.ntl.com>
          for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 23:00:49 +0100
Received: from [192.168.99.15] (really [82.18.123.115])
          by aamta11-winn.ispmail.ntl.com with ESMTP
          id <20050726220049.SDFC24042.aamta11-winn.ispmail.ntl.com@[192.168.99.15]>
          for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 23:00:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When installing Linux on a pair of new dual-opteron servers (16GB of RAM 
and a MegaRAID 320-2), neither the megaraid v1, nor v2 drivers could 
talk to the actual MegaRAID hardware. The v1 driver simply caused the 
system to lock up, wheras the v2 driver produces the error "megaraid: 
maibox adapter did not initialize" after a while.

Googling for the error produced this slightly old result, which fits the 
problem perfectly: 
http://lists.suse.com/archive/suse-amd64/2004-Jun/0345.html

And indeed, passing the argument "mem=3000000k" to the kernel allows the 
card to be detected fine by the v2 driver. We have a lot of 8GB Opterons 
running Megaraid cards fine, but this is the first time we've bought 
16GB models. This is the first problem we've seen, so I'm guessing that 
the MegaRAID firmware has issues writing to RAM higher than somewhere 
between 8 and 16GB...

Should we be looking for a new RAID card or is there a way to fix this? 
Why has seemingly nobody else had this problem?

Thanks in advance,

Russ Garrett
russ@last.fm

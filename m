From: "Vagin Andrey S." <shpagin@3ka.mipt.ru>
Subject: Documentation
Date: Mon, 24 Oct 2005 23:05:03 +0400
Message-ID: <1869392826.20051024230503@3ka.mipt.ru>
Reply-To: "Vagin Andrey S." <shpagin@3ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alcasar.3ka.mipt.ru ([194.85.81.10]:2212 "EHLO 3ka.mipt.ru")
	by vger.kernel.org with ESMTP id S1750930AbVJXTEy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 15:04:54 -0400
Received: from [194.85.81.89] (HELO stray.3ka.mipt.ru)
  by 3ka.mipt.ru (CommuniGate Pro SMTP 4.2.7)
  with ESMTP-TLS id 2958271 for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 23:04:51 +0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



I develop scsi disk driver.
Where can I find documentation?
How can I create driver with sector_size any 512 byte?

When I must declare, that sector_size equals 1024 for example?

p s Scsi disk isnt't phisical device, is virual, similar to iSCSI.


kernel: 2.4.27


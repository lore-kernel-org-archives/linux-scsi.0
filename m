From: Vijayan Prabhakaran <pvijayan@gmail.com>
Subject: Disk retries on error
Date: Wed, 2 Feb 2005 08:59:26 -0600
Message-ID: <d68fdf7d050202065917a56d45@mail.gmail.com>
Reply-To: Vijayan Prabhakaran <pvijayan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.207]:11280 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262323AbVBBO71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2005 09:59:27 -0500
Received: by wproxy.gmail.com with SMTP id 71so85557wra
        for <linux-scsi@vger.kernel.org>; Wed, 02 Feb 2005 06:59:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm new to the Linux SCSI community. I got a few questions on how SCSI
drivers handle read/write failures.

When there is a latent sector fault (unable to read/write into a
sector), or if the data is corrupted (CRC failed), does the SCSI
drivers reissue the command ?

Does this differ from one SCSI driver (say, for IBM disk) to another
(say, for Seagate) ?

>From my code browsing, I assume that retry happens in few cases. Some
of them are:

1. MEDIUM_ERROR 
What types of errors are classified as MEDIUM_ERROR ? Is this same as
data corruption ?

2. ABORTED_ERROR
Again, what types of errors are classified as this type ?

Any information regarding this will be greatly helpful.

Thanks,
Vijayan

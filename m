From: "H.Rosmanith (Kernel Mailing List)" <kernel@wildsau.enemy.org>
Subject: Re: *panic* on "send diagnostic"
Date: Wed, 29 Dec 2004 19:19:20 +0100 (MET)
Message-ID: <200412291819.iBTIJKlp022298@wildsau.enemy.org>
References: <200412291801.iBTI1GFC022288@wildsau.enemy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wildsau.idv.uni.linz.at ([193.170.194.34]:48527 "EHLO
	wildsau.enemy.org") by vger.kernel.org with ESMTP id S261390AbUL2SXX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 13:23:23 -0500
In-Reply-To: <200412291801.iBTI1GFC022288@wildsau.enemy.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H.Rosmanith (Kernel Mailing List)" <kernel@wildsau.enemy.org>
Cc: linux-scsi@vger.kernel.org

> 
> u_char snsbuf[32];
> sg_io_hdr_t ioh;
> u_char scsiCmd[5]={0x1d,};
  ^^^^^^^^^^^^^^^^^^^^^^^^^

ah, right, it should be scsiCmd[6] instead of 5. now, the message
"unknown opcode" doesnt appear anymore, however, when started
on /dev/sda (3ware RAID controller), I'll still get a panik.

/herp
 

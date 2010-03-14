From: Asdo <asdo@shiftmail.org>
Subject: LSISAS2008 stable?
Date: Mon, 15 Mar 2010 00:09:43 +0100
Message-ID: <4B9D6CB7.8060905@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:62821 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab0CNXKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Mar 2010 19:10:37 -0400
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
 id <01NKRB1UQEHSCCNDA8@mx.isti.cnr.it> for linux-scsi@vger.kernel.org; Mon,
 15 Mar 2010 00:09:37 +0100
Received: from [10.0.0.3] (host-78-12-76-61.cust-adsl.tiscali.it [78.12.76.61])
 by mx.isti.cnr.it (PMDF V6.5 #31826)
 with ESMTPSA id <01NKRB1YH1W6CA1RSU@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Mon, 15 Mar 2010 00:09:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi everybody
we are probably going to invest on a number of LSI SAS 9200-16e SAS2 
controllers which I believe are powered by the LSISAS2008 chipset, which 
we will connect to SAS1 expanders made by AIC.
We would not have time to test them in advance like buying a small 
number in advance.
So I am asking if there are any known problems with the Linux driver for 
such chipset LSISAS2008..?
(including hot-swap capability which we need, excluding the hot-swap 
rescan bug for the previous chipset reported by Michael Moore which I 
already read about in this ML... keeping fingers crossed on that...)
Thanks in advance for any replies
A.

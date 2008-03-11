From: Doron Shoham <dorons@voltaire.com>
Subject: using direct IO with sgp_dd
Date: Tue, 11 Mar 2008 09:40:08 +0200
Message-ID: <47D63758.9000601@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:20338 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbYCKHkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2008 03:40:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I wanted to use direct IO with sgp_dd.

I have done:

echo 1 > /proc/scsi/sg/allow_dio

sgp_dd if=/dev/sg1 of=/dev/null bs=512 bpt=128 thr=8 time=1 count=5M dio=1
time to transfer data was 2.236290 secs, 1200.36 MB/sec
5242880+0 records in
5242880+0 records out
Direct IO requested but incomplete 40960 times

What does it mean "Direct IO requested but incomplete 40960 times"?
And what could be the reason for this?

When using bpt smaller then 128 it doesn't happen.

Thanks,
Doron


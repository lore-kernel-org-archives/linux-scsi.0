From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - SCSI Host Number vs. Dell Servers
Date: Fri, 17 Sep 2004 19:01:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18F1C4500@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:12190 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S269050AbUIRABO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 20:01:14 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

We created a Linux SCSI low-level driver.  By using /proc/scsi/scsi or /proc/partition or /dev/scsi, 
I can see our driver is assigned host2 on Dell 1750 server (even though host1 doesn't seem been
used), and host1 on Dell 1850.  

My question is why Linux SCSI sub-system assigns host2 to our driver even though host1 doesn't
seem been used (host1 is not in /dev/scsi/)?  We are using RH Linux 9 (lk 2.4.20-30.9).

Thanks,


Lee


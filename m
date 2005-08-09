From: Jon Scottorn <jscottorn@possibilityforge.com>
Subject: Adaptec i2o controller
Date: Tue, 09 Aug 2005 09:59:57 -0600
Message-ID: <42F8D2FD.6070107@possibilityforge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.possibilityforge.com ([209.33.206.30]:43131 "EHLO
	possibilityforge.com") by vger.kernel.org with ESMTP
	id S964839AbVHIQAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 12:00:06 -0400
Received: from dev.possibilityforge.com ([209.33.206.3])
	by  with esmtp (Exim 4.50)
	id 1E2WWJ-0000lj-GK
	for linux-scsi@vger.kernel.org; Tue, 09 Aug 2005 10:00:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
 
  I have been running a 2.6.8 kernel with the adaptec i2o scsi
controller and I went to upgrade to the 2.6.12.4 kernel and when I
reboot into that kernel I get a kernel panic. I am wondering either what
I have done wrong or what has changed with the i2o driver between the
two kernels. 
Here is the error I get, I am summarizing because I have to type the
error in.

EIP is at adpt_isr+0x175/0x1f2
then has a stack and call trace:
(#0001,*0):c01035b2 oops
kernel panic - not syncing: Fatal exception in interrupt

Thanks in advance for any suggestions.

Jon

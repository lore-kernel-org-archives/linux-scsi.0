From: "linux@sockho.com" <linux@sockho.com>
Subject: stanby mode for cdrecorder
Date: 28 Mar 2003 12:06:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048849601.2584.7.camel@mahite>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [192.168.1.23] ([195.101.170.238])
	by adaro.host4u.net (8.11.6/8.11.6) with ESMTP id h2SB8r400559
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2003 05:08:54 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm new to this list, nice to meet you...

I am asking myself about putting the cdrecorder (mmc 3 compliant) in
stanby mode after a period on inactivity.

Do you think that it will increase its lifetime or is it ineffective ?

If yes, how can I send a standby timer command.
I saw that I need to send Mode sense command (0x1A) but I am unable to
find the stanby command.

Thanks for your help.

Thierry
France



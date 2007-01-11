From: Tarjei Huse <tarjei@scanventure.no>
Subject: Adaptect 9405w: What is the best solution?
Date: Thu, 11 Jan 2007 12:02:54 +0100
Message-ID: <45A6195E.7020103@scanventure.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.bergfald.no ([213.158.252.226]:1695 "EHLO
	mail2.bergfald.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276AbXAKLYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 06:24:08 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail2.bergfald.no (Postfix) with ESMTP id A6447296F71
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 12:03:01 +0100 (CET)
Received: from mail2.bergfald.no ([127.0.0.1])
 by localhost (mail2 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 18247-04 for <linux-scsi@vger.kernel.org>;
 Thu, 11 Jan 2007 12:02:54 +0100 (CET)
Received: from [192.168.6.100] (box80-64-200-29.static.sdsl.no [80.64.200.29])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.bergfald.no (Postfix) with ESMTP id 30C1B296F6A
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 12:02:54 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, I'm working on getting Linux to use my SATA drives on an IBM x306 running a HostRaid controller that uses the adaptech 9405w chipset.

I found this thread on the list:
 http://thread.gmane.org/gmane.linux.scsi/29040/focus=29040

What I'm wondering about is:
a) Where can I get the patches that mr Tuikov maintains for this chipset? 
b) Are they maintained wrt to different kernel versions, i.e. do they apply cleanly to a 2.6.20 or 2.6.16 kernel? 

c) In the thread Darrick Wong refers to another branch[1] that contains  (according to him) a lot of fixes for this chipset. Is that branch confirmed to work with my chipset?


My main goal is to get this box up and running using debian or ubuntu. I have managed to get it to run the debian 2.6.9 kernel as outlined in [2] using the adp94xx driver, but I cannot get that driver to compile on newer kernels.

I have also tried to compile the latest rc of the 2.6.20 kernel and loaded up the aic94xx driver + firmware. I then ended up getting the same errors that started the above mentioned thread on this list.

So what is the best solution here? Has anyone managed to get a newer kernel to run on this chipset?

1. http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=summary
2. http://www.jimmy.co.at/weblog/?p=71

Kind regards and thanks for any input.
Tarjei Huse




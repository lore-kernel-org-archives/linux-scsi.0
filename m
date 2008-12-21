From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: BUG: bad: [58e2a02eb18393e76a469580fedf7caec190eb5e] [SCSI] eata:
 convert to use the data buffer accessors
Date: Mon, 22 Dec 2008 02:38:16 +1030
Message-ID: <494E69F0.3060300@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55816 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbYLUQPH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2008 11:15:07 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LEQxL-0004Mw-3E
	for linux-scsi@vger.kernel.org; Sun, 21 Dec 2008 16:15:03 +0000
Received: from ppp121-45-91-187.lns10.adl6.internode.on.net ([121.45.91.187])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 21 Dec 2008 16:15:03 +0000
Received: from arthur.marsh by ppp121-45-91-187.lns10.adl6.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 21 Dec 2008 16:15:03 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ballabio_dario@emc.com

I've recently installed Debian on a PII-266 machine with DPT2044W SCSI 
controller.

Kernels 2.6.18-2.6.22 work fine, and kernels 2.6.23-2.6.27 lock up after 
loading the eata module using modprobe, with the error:

modprobe exited with preempt_count 1

I've run a git bisection and have a few more passes to go, but suspect 
the commit in the subject line,

[58e2a02eb18393e76a469580fedf7caec190eb5e] [SCSI] eata: convert to use 
the data buffer accessors

to be the patch which triggers the problem.

I'm not a C programmer, let alone a kernel programmer, but can build and 
check any suggested patches.

Is anyone successfully using the eata module since the data buffer 
accessors patch?

Is anyone able to examine the code to see if anything was done wrong in 
the data buffer accessors patch?

Regards,

Arthur.


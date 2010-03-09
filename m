From: Uprooter <uprooter@gmail.com>
Subject: Slow CCISS  ( not bug 13127 )
Date: Tue, 9 Mar 2010 14:04:00 +0200
Message-ID: <201003091404.01058.uprooter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:38083 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CIMEA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 07:04:00 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2848673fgg.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2010 04:03:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello list
I got a refurbished  HP DL360   server with CCISS controller.
SCSI I/O is really slow with *old* kernels like 2.6.26/27/28.

I have 2 new 147gb disks , controller is set to  raid0 configuration 
hdparm -t /dev/cciss/c0d0 gives me ~27.0 MB/s which is very poor.

I tried  gentoo/ubuntu/debian/centos and all gives the same result.
There is an open bug about regression of newer kernels and this controller 
however I'm  having poor results with old kernels as well.
http://bugzilla.kernel.org/show_bug.cgi?id=13127
I'll appreciate your help.
Thanks.

From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: is there a clean way to disable a scsi timer
Date: Fri, 27 Sep 2002 01:24:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10209270124.ZM103645@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by rj.sgi.com (8.12.2/8.12.2/linux-outbound_gateway-1.2) with ESMTP id g8R6Ouil003217
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2002 23:24:56 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.9.3/8.9.3) with ESMTP id BAA88320
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 01:24:56 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.9.3/8.9.3) id BAA03724
	for linux-scsi@vger.kernel.org; Fri, 27 Sep 2002 01:24:36 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a host driver that does its own timeout and error handling.  Is there
a clean way to disable the midlayer timeout handling?  It appears that I
can just call scsi_disable_timer() from the queuecommand function, but
I'd prefer something less nasty.

thanks

jeremy

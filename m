From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: is there a clean way to disable a scsi timer
Date: Fri, 27 Sep 2002 01:29:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10209270129.ZM103701@classic.engr.sgi.com>
References: <10209270124.ZM103645@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by zok.sgi.com (8.12.2/8.12.2/linux-outbound_gateway-1.2) with ESMTP id g8R7VST1029936
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 00:31:28 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.9.3/8.9.3) with ESMTP id BAA11976
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 01:30:02 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.9.3/8.9.3) id BAA03761
	for linux-scsi@vger.kernel.org; Fri, 27 Sep 2002 01:29:42 -0700 (PDT)
In-Reply-To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
        "is there a clean way to disable a scsi timer" (Sep 27,  1:24am)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Misremembered the name -- sorry.

s/scsi_disable_timer/scsi_delete_timer/

On Sep 27,  1:24am, Jeremy Higdon wrote:
> 
> I have a host driver that does its own timeout and error handling.  Is there
> a clean way to disable the midlayer timeout handling?  It appears that I
> can just call scsi_disable_timer() from the queuecommand function, but
> I'd prefer something less nasty.

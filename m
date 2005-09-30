From: Fawad Lateef <fawadlateef@gmail.com>
Subject: Re: accessing the scsi disk from a kernel module
Date: Fri, 30 Sep 2005 11:00:36 +0500
Message-ID: <1e62d137050929230019fcbfb6@mail.gmail.com>
References: <433CCCD2.3000003@cdac.in>
Reply-To: Fawad Lateef <fawadlateef@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.192]:51865 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932559AbVI3GAh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 02:00:37 -0400
Received: by wproxy.gmail.com with SMTP id i2so183111wra
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2005 23:00:36 -0700 (PDT)
In-Reply-To: <433CCCD2.3000003@cdac.in>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karthik Sarangan <karthiks@cdac.in>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On 9/30/05, Karthik Sarangan <karthiks@cdac.in> wrote:
> what do I write in a kernel module for accessing a scsi disk device?
>

What do u mean by this ??? Are you writing a driver for SCSI Disk or
Want to do read/write on it using its own driver ??? For read/write
using its own driver you can use/call generic_make_request (function
from block/ll_rw_blk.c) from your kernel module to send requests to
any block device available on the system and kernel will do the
creating and sending request to correct block device whether that will
be a SCSI disk or any disk .... And if you want directly to use the
SCSI device then you have to make requests using SCSI protocol .....

--
Fawad Lateef

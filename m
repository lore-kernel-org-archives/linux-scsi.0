From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Degraded I/O performance, since 2.5.41
Date: Thu, 10 Oct 2002 16:54:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210102354.g9ANsgT11735@localhost.localdomain>
References: <haveblue@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA24203
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 16:54:43 -0700
In-Reply-To: Message from Dave Hansen <haveblue@us.ibm.com>
   of "Thu, 10 Oct 2002 16:48:47 PDT." <3DA611DF.3000206@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

haveblue@us.ibm.com said:
> I would guess that it's just making stupid, er.... suboptimal,
> decisions about the length for my hardware.  With a controller as
> "smart" as the ServeRAID, I would imagine the best approach is to just
> throw as many requests at it at one time as you can, then let the
> controller sort it out.  Doug, I noticed that you changed a bunch of
> code to the aic7xxx_old driver, is this just a lack of optimization in
> the ServeRAID driver?

OK, I bet this is because the ips driver now no longer actually does tagged 
command queueing.  I'll go an check.

James



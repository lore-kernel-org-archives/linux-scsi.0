From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Eliminate signals entirely from the mid-layer
Date: Fri, 10 Jan 2003 17:05:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301102205.h0AM56L06192@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA09861
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2003 14:05:08 -0800
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Fri, 10 Jan 2003 14:01:26 PST." <20030110220126.GB1143@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> I will try to test it today or tomorrow. I am already setup for some
> error handler fault tests for a qlogicisp error handling update. 

Thanks.  I forgot to say that it applies on top of Willem Riede's signal 
changes patch.

I've pushed it up to scsi-misc-2.5 to make the dependencies easier to manage.

James



From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 19:31:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209242331.g8ONVCg03591@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA24998
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2002 16:31:20 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Tue, 24 Sep 2002 16:26:30 PDT." <20020924232630.GD1330@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Russell King <rmk@arm.linux.org.uk>, Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> If you want me to I can add it to a patch bundle I already have that
> includes ports of Russell's previous changes that apply on top of my
> 2.5 scsi_error cleanup patch. 

Sounds good.  Do you have a copy of the error handler clean up that applies 
cleanly to 2.5.38 (after the removal of scsi_queue.c)?

James



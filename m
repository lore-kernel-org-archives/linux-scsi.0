From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 24 May 2002 09:17:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205241317.g4ODHF001815@localhost.localdomain>
References: <majordomo_linux@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA07958
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2002 06:17:23 -0700
In-Reply-To: Message from rakesh rakesh <majordomo_linux@yahoo.com>
   of "Fri, 24 May 2002 01:34:27 PDT." <20020524083427.4608.qmail@web11005.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: rakesh rakesh <majordomo_linux@yahoo.com>
Cc: Aron Zeh <ARZEH@de.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, linux-scsi@vger.kernel.org

majordomo_linux@yahoo.com said:
> But the whole hypothesis is that at any point of time mid level should
> be able to queue at least one command to low level driver.Reference to
> doc by  Eric at www.andante.org 

That was the assumption years ago when the new error handler was created.  
Nowadays, I believe the block layer can stand to have all outstanding commands 
pushed back with no detrimental effect (otherwise blk_queue_invalidate_tags() 
wouldn't work) as long as we get the conditions for restart correct.

James



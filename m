From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Mon, 21 Oct 2002 11:29:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210211629.g9LGTqY02713@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA24855
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2002 09:29:55 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id JAA24766
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2002 09:29:53 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g9LGTqY02713
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2002 11:29:52 -0500
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Mon, 21 Oct 2002 12:16:18 EDT." <20021021161617.GA28914@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

dledford@redhat.com said:
> Yeah, David Jeffery of Adaptec (the current maintainer of the ips
> driver)  already sent a fix for this to Linus, so it should be in
> 2.5.44 I think.   If not, let me know and I'll add it to my queue I'm
> preparing for when  Linus comes back. 

The last change to ips was you on 16 October, so it's probably still AWOL.

I'm keeping the trivial miscellaneous changes in linux-scsi.bkbits.net/scsi-mis
c-2.5 you can look at the change logs (even if you don't run bitkeeper) to see 
what's in there.

James





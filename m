From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi host cleanup 3/3 (driver changes)
Date: Thu, 10 Oct 2002 09:59:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210101659.g9AGxCA02928@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA07215
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 09:59:14 -0700
Received: from localhost.localdomain (vpn-233.mtv1.steeleye.com [172.16.1.233])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id JAA07126
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 09:59:12 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g9AGxCA02928
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 09:59:12 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Thu, 10 Oct 2002 09:46:33 PDT." <20021010164633.GA1348@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I (finally) got around to looking at the patches.  There were only a few minor 
quibbles, really boiling down to the fact that you export some functions 
beginning shost_ instead of scsi_ (shost_tp_for_each_host, 
shost_chk_and_release).  I can't see any reason why this might cause a naming 
clash, but I think it is safer to stick to exports beginning with scsi_.

Also, why do we now have some functions beginning scsi_host and some beginning 
scsi_shost?  Could we just use one or the other (I'd vote for scsi_host, since 
it's shorter).

James



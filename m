From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] first cut at fixing unable to requeue with no outstanding
 commands
Date: Mon, 30 Sep 2002 20:38:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210010038.g910cnB31623@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id RAA23910
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 17:38:53 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id RAA23821
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 17:38:51 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g910cnB31623
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 20:38:49 -0400
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Mon, 30 Sep 2002 16:28:11 PDT." <20020930232811.GA1372@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> Are we guaranteed that blk_run_queues will be called for all types of
> I/O? 

Pretty much, it looks like.  It's mainly triggered by I/O stuff in fs, 
including the buffer functions, so I think the assumption that we will be 
called eventually is good.

James




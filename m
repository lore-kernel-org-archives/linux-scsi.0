From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi_scan.c question
Date: Wed, 16 Oct 2002 14:41:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210162141.g9GLfpE04327@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA10693
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 14:41:54 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id OAA10604
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 14:41:52 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g9GLfpE04327
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 14:41:51 -0700
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 16 Oct 2002 17:35:18 EDT." <20021016213518.GE8159@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Is anyone still working on this code or have the changes other people
> wanted to make all been integrated? 

I have some changes to throw most of it away and re-implement it in user space 
using hotplug instead.  I think this type of thing is a little radical for the 
eve of 2.6, so feel free to alter scsi_scan.c in any way you want.

James



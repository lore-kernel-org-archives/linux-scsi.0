From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] add request prep functions to SCSI
Date: Wed, 06 Nov 2002 18:43:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211062343.gA6NhdR06261@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA30229
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 15:43:42 -0800
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id PAA30140
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 15:43:40 -0800
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id gA6NhdR06261
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 18:43:39 -0500
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 06 Nov 2002 18:16:45 EST." <20021106231645.GK22177@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Hmmm...the current pace of scsi patches is starting to get hard to
> keep up  with.  Do we have a unified bk tree with all the patches we
> want Linus to  apply in it as of yet?  I know a lot of stuff has come
> through just in the  last day and I'm starting to see a lot of areas
> where there is going to be  conflict between patches going forward. 

I'm just getting ready to add Patrick's patch to scsi-for-linus-2.5 and bring 
it up to date with the BK current.  Should be about another hour (depending on 
how long it takes me to compile and test)

James



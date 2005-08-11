From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Thu, 11 Aug 2005 20:48:50 +0200
Message-ID: <OFCE6F94E7.B33AAE6C-ONC125705A.00670256-C125705A.0067378D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:5536 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S932357AbVHKSs4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 14:48:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Simon Derr <Simon.Derr@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, mingo@redhat.com

        Simon Derr <Simon.Derr@bull.net> wrote:

  > It is sufficient to have a few HBAs and to insmod/rmmod the driver a 
few 
  > times.

  > Since the host_no is choosen with a mere counter increment 
  > in scsi_host_alloc():

  >       shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */

  > Unused `host_no's are not reused and the 100 limit is reached even on 
  > smaller systems.

  > I have no idea of why someone would do repeated insmod/rmmods, though.
  > (But someone did).

You even don't have to use insmod/rmmod.  On s390 (using zfcp) it
suffices to take adapters offline and online (triggered via VM,
hardware, or within Linux). Just do so about 100 times ... You
know the result.


Regards,

Andreas

From: "'Dave Olien'" <dmo@osdl.org>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Wed, 13 Oct 2004 15:09:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041013220907.GB30273@osdl.org>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com> <20041013214629.GA30273@osdl.org> <1097704592.1714.266.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:63393 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S269875AbUJMWJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 18:09:13 -0400
Content-Disposition: inline
In-Reply-To: <1097704592.1714.266.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Qi, Yanling" <yanling.qi@engenio.com>, Douglas Gilbert <dougg@torque.net>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Sure, I'll get on it right away.

Dave

On Wed, Oct 13, 2004 at 04:56:25PM -0500, James Bottomley wrote:
> On Wed, 2004-10-13 at 16:46, 'Dave Olien' wrote:
> > Now, on to figuring out why some of these requeued commands
> > fail the requeue.
> 
> Yes, I've been wondering that too ... either the second remap is wrong,
> or something goes awry with the segment recount on a requeue.
> 
> In the unit attention, could you print out cmd->use_sg and
> cmd->request->nr_phys_segments ... just to see what values got set up
> the first time around, which might give a clue where to look for the
> problem.
> 
> James
> 

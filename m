From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: 13 Oct 2004 16:56:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097704592.1714.266.camel@mulgrave>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
	<20041013214629.GA30273@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22454 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269866AbUJMV5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 17:57:17 -0400
In-Reply-To: <20041013214629.GA30273@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Dave Olien' <dmo@osdl.org>
Cc: "Qi, Yanling" <yanling.qi@engenio.com>, Douglas Gilbert <dougg@torque.net>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-13 at 16:46, 'Dave Olien' wrote:
> Now, on to figuring out why some of these requeued commands
> fail the requeue.

Yes, I've been wondering that too ... either the second remap is wrong,
or something goes awry with the segment recount on a requeue.

In the unit attention, could you print out cmd->use_sg and
cmd->request->nr_phys_segments ... just to see what values got set up
the first time around, which might give a clue where to look for the
problem.

James



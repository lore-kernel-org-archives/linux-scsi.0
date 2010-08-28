From: Julia Lawall <julia@diku.dk>
Subject: question about drivers/scsi/scsi_transport_fc.c
Date: Sat, 28 Aug 2010 19:11:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:36006 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab0H1RLO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2010 13:11:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
Cc: joe@perches.com

The function fc_bsg_goose_queue in the file drivers/scsi/scsi_transport_fc.c
contains the following code:

        flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
                  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);

I have the impression that this is always 0.  QUEUE_FLAG_REENTER is 
defined with quite a lot of other constants, so I don't really have a 
guess as to what was intended.

thanks,
julia

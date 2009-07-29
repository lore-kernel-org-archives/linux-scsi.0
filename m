From: Julia Lawall <julia@diku.dk>
Subject: question about scsi_tgt_lib.c
Date: Wed, 29 Jul 2009 18:11:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907291808070.22045@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:36377 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbZG2QQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 12:16:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The file drivers/scsi/scsi_tgt_lib.c contains the function 
scsi_host_get_command, which contains the following code:

        rq->special = cmd;
        rq->cmd_type = REQ_TYPE_SPECIAL;
        rq->cmd_flags |= REQ_TYPE_BLOCK_PC;
        rq->end_io_data = tcmd;

Is it correct that the cmd_flags field should be initialized to something 
including REQ_TYPE_BLOCK_PC?  Normally this value is used to initialize 
the cmd_type field.

julia

From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: [2.4.21] Spurious ABORTs
Date: Fri, 23 Sep 2005 17:28:03 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD1D3@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50647 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751308AbVIWV2J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 17:28:09 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j8NLNpSW001799
	for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2005 14:23:51 -0700 (PDT)
Received: from EXA-ATLANTA.se.lsil.com (atl1.se.lsil.com [147.145.16.4])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j8NLS4Ze010682
	for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2005 14:28:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>

Hello List,

I am running rather heavy IO's on our MegaRAID controller on a
Red Hat 3.0 Gold (2.4.21-4.Elsmp) 32 kernel. After a while, I 
notice that the OS sends the abort requests for commands that
the driver has completed a while ago! I am using the unused
struct scsi_cmnd->SCp fields to record the entry/exit timestamps
and also the status of each commands while it is being processed.
When I get the abort request, I am seeing that driver had completed
the command already.

I know that this is not an appropriate list to ask RH specific
question. But I wasn't sure if it RH specific bug or if there are
any known situations where 2.4 based kernels would try to _abort_
previously completed commands. I tried tracing the SCSI mid-layer
code and I quickly got lost.

Thanks in advance for any help.

Sincerely,
Sreenivas Bagalkote

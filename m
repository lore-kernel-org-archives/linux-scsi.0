From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: Fix MTMKPART to work with newer drives
Date: Tue, 09 Feb 2016 21:24:06 -0500
Message-ID: <yq1h9hhb8vt.fsf@sermon.lab.mkp.net>
References: <alpine.LSU.2.11.1602092146480.4677@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38223 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbcBJCYW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 21:24:22 -0500
In-Reply-To: <alpine.LSU.2.11.1602092146480.4677@xnv.znxvfnen.cevingr> (Kai
	Makisara's message of "Tue, 9 Feb 2016 21:56:55 +0200 (EET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, "Seymour, Shane M" <shane.seymour@hpe.com>, Douglas Gilbert <dgilbert@interlog.com>, Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>

>>>>> "Kai" == Kai Makisara <Kai.Makisara@kolumbus.fi> writes:

Kai> Change the MTMKPART operation of the MTIOCTOP ioctl so that it
Kai> works also with current drives (LTO-5/6, etc.). Send a separate
Kai> FORMAT MEDIUM command if the partition mode page indicates that
Kai> this is required. Use LOAD to position the tape at the beginning of
Kai> tape.

Kai> The operation is extended so that if the argument is negative, its
Kai> absolute value specifies the size of partition 0, which is the
Kai> physically first partition of the tape.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

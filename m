From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: clear ILI if Medium Error
Date: Mon, 25 Apr 2016 22:09:21 -0400
Message-ID: <yq11t5ti0j2.fsf@sermon.lab.mkp.net>
References: <alpine.LSU.2.20.1604180843100.1620@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21265 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbcDZCJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 22:09:39 -0400
In-Reply-To: <alpine.LSU.2.20.1604180843100.1620@xnv.znxvfnen.cevingr> (Kai
	Makisara's message of "Mon, 18 Apr 2016 08:47:18 +0300 (EEST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, mlombard@redhat.com

>>>>> "Kai" == Kai Makisara <Kai.Makisara@kolumbus.fi> writes:

Kai> Some drives set the ILI flag together with MEDIUM ERROR sense
Kai> code. Clear the ILI flag in this case so that the medium error will
Kai> be handled. The problem was reported by Maurizio Lombardi.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

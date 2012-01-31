From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/5] scsi: Add a report opcode helper
Date: Tue, 31 Jan 2012 15:16:13 -0500
Message-ID: <yq1ty3bsk4y.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<1327969892-5090-5-git-send-email-martin.petersen@oracle.com>
	<4F2846CE.2050907@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33344 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2AaUQr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2012 15:16:47 -0500
In-Reply-To: <4F2846CE.2050907@garzik.org> (Jeff Garzik's message of "Tue, 31
	Jan 2012 14:53:50 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

>>>>> "Jeff" == Jeff Garzik <jeff@garzik.org> writes:

Hey Jeff,

Jeff> While this is bare minimum acceptable, remember this covers ATA
Jeff> and ATAPI devices both.

Proper write same support is making its way through T13. It is my intent
to wire it up in libata once I find a SATA device that implements it.


Jeff> A preferred patch would simulate the RSOC op for ATA devices, and
Jeff> only apply the above condition to ATAPI devices.

I can do that if you insist. It just adds a superfluous heuristic to the
SCSI pile since I still need the existing flag to short out USB and
FireWire. I also can't rely exclusively on RSOC since only very recent
devices support it (and not even all of them)...

-- 
Martin K. Petersen	Oracle Linux Engineering

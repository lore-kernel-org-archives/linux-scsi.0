From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 19:24:36 -0400
Message-ID: <yq1od25jjyj.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.0809301538100.3494-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:18297 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYI3XZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 19:25:03 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809301538100.3494-100000@iolanthe.rowland.org> (Alan Stern's message of "Tue\, 30 Sep 2008 15\:49\:21 -0400 \(EDT\)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Are there types of failure for which we really don't want to
Alan> print anything?  For example, what about UNIT ATTENTION for
Alan> media changes or the DIX/DIF failures (should those both be
Alan> DIF?)?

ILLEGAL REQUEST + 10/[123] indicates that the HBA rejected the request
(DIX).

ABORTED COMMAND + 10/[123] indicates that the device found a
corruption error (DIF).

-- 
Martin K. Petersen	Oracle Linux Engineering


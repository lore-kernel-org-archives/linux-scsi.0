From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Remove SUGGEST flags
Date: Sun, 04 Jan 2009 11:18:54 +0200
Message-ID: <49607EFE.9070802@panasas.com>
References: <yq1iqov4hf0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:18783 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbZADJS7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 04:18:59 -0500
In-Reply-To: <yq1iqov4hf0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> The SUGGEST_* flags in the SCSI command result have been out of fashion
> for a while and we don't actually use them in the error handling.
> Remove the remaining occurrences.
> 

OK So is there an up-to-date definitive document that explains all the
bit-fields and their possible values of the scsi_cmnd's result member?

> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

Thanks, these confused me.
Boaz

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Remove SUGGEST flags
Date: Sun, 04 Jan 2009 21:30:52 -0500
Message-ID: <yq1d4f24h7n.fsf@sermon.lab.mkp.net>
References: <yq1iqov4hf0.fsf@sermon.lab.mkp.net>
	<49607EFE.9070802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:26190 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZAECbJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 21:31:09 -0500
In-Reply-To: <49607EFE.9070802@panasas.com> (Boaz Harrosh's message of "Sun\, 04 Jan 2009 11\:18\:54 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> Martin K. Petersen wrote:
>> The SUGGEST_* flags in the SCSI command result have been out of
>> fashion for a while and we don't actually use them in the error
>> handling.  Remove the remaining occurrences.
>> 

Boaz> OK So is there an up-to-date definitive document that explains all
Boaz> the bit-fields and their possible values of the scsi_cmnd's result
Boaz> member?

Not that I know of :|

-- 
Martin K. Petersen	Oracle Linux Engineering

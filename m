From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] sd: Allow sd_print_sense_hdr to be called outside of sd.c
Date: Mon, 09 Jun 2008 11:07:21 -0400
Message-ID: <yq1k5gyk5p2.fsf@sermon.lab.mkp.net>
References: <yq1iqwml61r.fsf@sermon.lab.mkp.net>
	<20080609070650.GA4770@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:15654 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYFIPHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 11:07:46 -0400
In-Reply-To: <20080609070650.GA4770@infradead.org> (Christoph Hellwig's message of "Mon\, 9 Jun 2008 03\:06\:50 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Fri, Jun 06, 2008 at 03:25:20PM -0400, Martin K. Petersen wrote:
>> +EXPORT_SYMBOL(sd_print_sense_hdr);

Christoph> no need to export it, it should only be called from
Christoph> sd_mod.ko

Legacy cruft.  Fixed.

-- 
Martin K. Petersen	Oracle Linux Engineering


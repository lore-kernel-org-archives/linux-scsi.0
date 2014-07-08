From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
 messages.
Date: Tue, 08 Jul 2014 10:36:25 +0200
Message-ID: <53BBAD89.60303@redhat.com>
References: <1402042235-7246-1-git-send-email-mlombard@redhat.com> <20140625110632.GE19181@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958B4C8CD@G9W0745.americas.hpqcorp.net> <20140703084108.GA4296@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaGHIgy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2014 04:36:54 -0400
In-Reply-To: <20140703084108.GA4296@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On 07/03/2014 10:41 AM, Christoph Hellwig wrote:
> On Wed, Jun 25, 2014 at 08:38:47PM +0000, Elliott, Robert (Server Storage) wrote:
>> Since the ACTION_FAIL case always prints the sense key
>> and additional sense code:
> 
>> perhaps the description string should be removed altogether?
> 
> 
> I'm tempted to agree and just remove the description.  Do you want to
> send a patch for this?

So I'll get rid of the "description" string completely...
I'm going to send a new patch later today.

Regards,
Maurizio Lombardi

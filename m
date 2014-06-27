From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/4] scsi_scan: Fixup scsilun_to_int()
Date: Fri, 27 Jun 2014 09:12:32 +0200
Message-ID: <53AD1960.70703@acm.org>
References: <1403702859-74437-1-git-send-email-hare@suse.de> <1403702859-74437-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:45866 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaF0HMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 03:12:33 -0400
In-Reply-To: <1403702859-74437-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/25/14 15:27, Hannes Reinecke wrote:
> scsilun_to_int() has an error which prevents it from generating
> correct LUN numbers for 64bit values.
> Also we should remove the misleading comment about portions of
> the LUN being ignored; the initiator should treat the LUN as
> an opaque value.
> And, finally, the example given should use the correct
> prefix (here: extended flat space addressing scheme).

I'm still not enthusiast about the byte reordering by scsilun_to_int()
for extended logical unit addressing. But I can confirm that this patch
passed the test that failed with the previous version of the 64-bit LUN
patch series. So if you want you can add "Tested-by: Bart van Assche
<bvanassche@acm.org>".

Best regards,

Bart.

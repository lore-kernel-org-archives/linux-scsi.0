From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] target: Fix zero-length regressions in v3.8-rc1 code
Date: Wed, 30 Jan 2013 10:24:02 +0100
Message-ID: <5108E6B2.8090101@redhat.com>
References: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab3A3JYZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 04:24:25 -0500
In-Reply-To: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>

Il 29/01/2013 23:26, Nicholas A. Bellinger ha scritto:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi folks,
> 
> The following are a handful of zero-length CDB regression bugfixes to address
> breakage introduced by the recent sense_reason_t conversion in v3.8-rc1 code,
> which incorrectly assumed CHECK_CONDITION status (in all CDB emulation cases)
> when NULL was returned by transport_kmap_data_sg().
> 
> Please review, as I'd like to get these into v3.8-rc6.
> 
> Thank you,
> 
> --nab
> 
> Nicholas Bellinger (3):
>   target: Fix zero-length INQUIRY additional sense code regression
>   target: Fix zero-length MODE_SENSE regression
>   target: Fix zero-length READ_CAPACITY_16 regression
> 
>  drivers/target/target_core_sbc.c |   18 +++++++--------
>  drivers/target/target_core_spc.c |   44 +++++++++----------------------------
>  2 files changed, 19 insertions(+), 43 deletions(-)
> 

Looks good, but given the mess I made in my own zero-length patches,
don't really count it as a Reviewed-by.

Paolo

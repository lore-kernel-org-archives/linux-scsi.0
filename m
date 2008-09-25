From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: lpfc warnings on sparc64
Date: Thu, 25 Sep 2008 08:36:48 -0700
Message-ID: <1222357008.3610.12.camel@localhost.localdomain>
References: <Pine.SOC.4.64.0809251006540.6342@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42796 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbYIYPhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 11:37:05 -0400
In-Reply-To: <Pine.SOC.4.64.0809251006540.6342@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org

On Thu, 2008-09-25 at 11:14 +0300, Meelis Roos wrote:
> Noticed this wgile compiling 2.6.27-rc7+git on sparc64 - maybe it is of 
> interest.
> 
>   CC [M]  drivers/scsi/lpfc/lpfc_sli.o
> drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli_poll_fcp_ring':
> drivers/scsi/lpfc/lpfc_sli.c:1365: warning: array subscript is above array bounds
> drivers/scsi/lpfc/lpfc_sli.c:1365: warning: array subscript is above array bounds
> drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli_handle_fast_ring_event':
> drivers/scsi/lpfc/lpfc_sli.c:1541: warning: array subscript is above array bounds
> drivers/scsi/lpfc/lpfc_sli.c:1541: warning: array subscript is above array bounds

As best I can tell this is a bogus warning ... it triggers on x86 as
well, but I can't find any reason gcc should think there's an array
bounds error.

James



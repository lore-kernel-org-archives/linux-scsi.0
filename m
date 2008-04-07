From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Add more debug output to sas_scsi_recover_host or
	sas_eh_handle_sas_errors
Date: Mon, 07 Apr 2008 09:36:14 -0500
Message-ID: <1207578974.3838.4.camel@localhost.localdomain>
References: <47FA2E1B.6020709@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50335 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758193AbYDGOgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 10:36:19 -0400
In-Reply-To: <47FA2E1B.6020709@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-04-07 at 16:22 +0200, Raoul Bhatia [IPAX] wrote:
> is there any sens in adding more debug output to sas_scsi_recover_host
> or sas_eh_handle_sas_errors?
> 
> e.g. put out SAS_ADDR(task->dev->sas_addr) so that we know whether
> the error is always occuring on one phy/port/etc. ?
> 
> the reason for doing this is basically my problems with the aic94xx
> driver, outlined in http://marc.info/?t=120603924200004.

Probably not really ... it looks like a standard protocol error thrown
by a Seagate driver, as I said.

Did reducing the queue depth and increasing the retries have any
mitigating effect at all?

The correct fix, which is to handle the REQ_TASK_ABORT on the fly is
still in the works.

James



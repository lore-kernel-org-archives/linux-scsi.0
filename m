From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] pm8001: fix pm8001_store_update_fw
Date: Wed, 30 Jul 2014 16:10:08 +0400
Message-ID: <1406722208.4865.57.camel@jarvis>
References: <1406721810-4591-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44576 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbaG3MKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:10:12 -0400
In-Reply-To: <1406721810-4591-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, thenzl@redhat.com, Viswas.G@pmcs.com, pmchba@pmcs.com

On Wed, 2014-07-30 at 17:33 +0530, Suresh Thiagarajan wrote:
> From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> 
> The current implementation may mix the negative value returned
> from pm8001_set_nvmd with with count. -(-ENOMEM) could be interpreted
> as bytes programmed, this patch fixes it.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

This author and signoff chain doesn't make sense.  Is the patch from
Tomas Henzl?  In which case the From: field is wrong; it should read

From: Tomas Henzl <thenzl@redhat.com>

James



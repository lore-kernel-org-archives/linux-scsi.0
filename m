From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 4/6] lpfc: use SCSI_MLQUEUE_TARGET_BUSY when catching
 the rport transition race
Date: Tue, 19 Aug 2008 11:27:09 -0400
Message-ID: <48AAE64D.9010000@emulex.com>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu> <1219004683-6468-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40158 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYHSP11 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2008 11:27:27 -0400
In-Reply-To: <1219004683-6468-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ack

-- james s

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> We do want to call right back into the queuecommand during the race,
> so we can just use SCSI_MLQUEUE_TARGET_BUSY.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Smart <James.Smart@Emulex.Com>
> 
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c

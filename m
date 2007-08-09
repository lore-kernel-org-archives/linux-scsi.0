From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Emulex FC HBA driver: fix overflow of statically allocated
 array
Date: Thu, 09 Aug 2007 15:32:08 -0400
Message-ID: <46BB6BB8.4000509@emulex.com>
References: <200708092047.16101.jesper.juhl@gmail.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59789 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762924AbXHITcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2007 15:32:10 -0400
In-Reply-To: <200708092047.16101.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

ACK

-- james s

Jesper Juhl wrote:
> I propose this patch, that simply changes the 'hbqno > LPFC_MAX_HBQS' 
> into 'hbqno >= LPFC_MAX_HBQS' as a possible fix.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)


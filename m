From: James Smart <James.Smart@Emulex.Com>
Subject: Re: scsi: constify VFTs
Date: Tue, 13 Jan 2009 10:28:28 -0500
Message-ID: <496CB31C.9060404@emulex.com>
References: <alpine.LSU.2.00.0901111037460.9874@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901111038370.9874@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49735 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZAMP2g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 10:28:36 -0500
In-Reply-To: <alpine.LSU.2.00.0901111038370.9874@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

ACK

-- james s

Jan Engelhardt wrote:
> parent 55840de5a8bee6494db6a79c231ec76e22417534 (v2.6.29-rc1-4-g55840de)
> commit 2b9b79b49bef5f00559bb275400ae024434db780
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Jan 11 10:37:26 2009 +0100
> 
> scsi: constify VFTs
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c |   16 ++++++++--------
>  drivers/scsi/sg.c                |   30 +++++++++++++++---------------
>  2 files changed, 23 insertions(+), 23 deletions(-)

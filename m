From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Adaptec AIC-9410W (AIC94xx) + SATA HDDs
Date: Wed, 26 Mar 2008 07:35:09 -0700
Message-ID: <1206542109.3019.3.camel@localhost.localdomain>
References: <47EA5A3B.1070200@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41097 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYCZOfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 10:35:15 -0400
In-Reply-To: <47EA5A3B.1070200@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-26 at 15:14 +0100, Raoul Bhatia [IPAX] wrote:
> can anyone point me out, why the adaptec aic-9410W sas controller
> detects my sata drive but the kernel does not?
[...]
> sas: unhandled device 5

This is what libsas produces when it's compiled with CONFIG_SCSI_SAS_ATA
set to N.  You need to recompile libsas with support for ATA devices
(it's a separate compile option because it sucks in the whole of libata
and thus doubles the size of the code).

James




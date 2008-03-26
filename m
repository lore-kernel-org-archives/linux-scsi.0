From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: Adaptec AIC-9410W (AIC94xx) + SATA HDDs
Date: Wed, 26 Mar 2008 17:09:23 +0100
Message-ID: <47EA7533.8030304@ipax.at>
References: <47EA5A3B.1070200@ipax.at> <1206542109.3019.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:54256 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbYCZQJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 12:09:25 -0400
In-Reply-To: <1206542109.3019.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2008-03-26 at 15:14 +0100, Raoul Bhatia [IPAX] wrote:
>> can anyone point me out, why the adaptec aic-9410W sas controller
>> detects my sata drive but the kernel does not?
> [...]
>> sas: unhandled device 5
> 
> This is what libsas produces when it's compiled with CONFIG_SCSI_SAS_ATA
> set to N.  You need to recompile libsas with support for ATA devices
> (it's a separate compile option because it sucks in the whole of libata
> and thus doubles the size of the code).

thanks, this is working now. sorry for bothering you ;)

cheers,
raoul
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________

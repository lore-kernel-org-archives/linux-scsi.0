From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 22:08:56 +0100
Message-ID: <47E2D268.2070609@ipax.at>
References: <47E2B044.70705@ipax.at>	 <1206039714.3038.40.camel@localhost.localdomain> <47E2B7EF.1050203@ipax.at> <1206043027.3038.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:35975 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbYCTVJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 17:09:01 -0400
In-Reply-To: <1206043027.3038.48.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

hi james,

James Bottomley wrote:
 > A work around might be to lower the queue depth to say 4 or 8 and up the
 > retries (this latter can only be done by altering the SD_MAX_RETRIES
 > parameter in include/scsi/sd.h and recompiling).

any suggestions for these parameters:

include/scsi/sd.h:
 > #define SD_TIMEOUT              (30 * HZ)
 > #define SD_MOD_TIMEOUT          (75 * HZ)
 >
 > #define SD_MAX_RETRIES          5
 > #define SD_PASSTHROUGH_RETRIES  1

shall i alter the timeouts?

what is a good value for the retries? time it by 2? by 5? by 10?


moreover, where can i lower the queue?

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

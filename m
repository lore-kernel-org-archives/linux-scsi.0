From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: aic94xx driver woes continued
Date: Mon, 31 Mar 2008 22:23:27 +0200
Message-ID: <47F1483F.2030100@ipax.at>
References: <651476.15877.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:55321 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbYCaUXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 16:23:09 -0400
In-Reply-To: <651476.15877.qm@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ltuikov@yahoo.com, James Bottomley <James.Bottomley@HansenPartnership.com>

resending, as somehow this message did not show up.

cheers,
raoul
-------- Original Message --------
Hello Luben,

On Sat, 29 Mar 2008 15:33:46 -0700 (PDT), Luben Tuikov <ltuikov@yahoo.com>
wrote:
>> This is all normal.  Seagate drives are known for throwing
>> protocol
>> errors under stress at certain revs of firmware.
>> That's what
>> REQ_TASK_ABORT, reason=0x6 is.
> 
> Reason 6 just means a "Protocol Error", without access to the HW
> registers, sequencer and most importantly a protocol link trace of
> the problem for analysis, you cannot be sure whose fault it is and why.

so may i ask what your advice would be? i can (try to) provide you
with more information and even access to this hardware.

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

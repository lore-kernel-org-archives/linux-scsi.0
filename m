From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Thu, 04 Dec 2014 20:05:05 -0800
Message-ID: <54812EF1.9030701@vlnb.net>
References: <201412040742.sB47gbGX032229@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56253 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbaLEEFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 23:05:16 -0500
In-Reply-To: <201412040742.sB47gbGX032229@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com, Duane Grigsby <duane.grigsby@qlogic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Dr. Greg Wettstein wrote on 12/03/2014 11:42 PM:
> On Dec 3,  8:59pm, Vladislav Bolkhovitin wrote:
> } Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
> 
>> Dr. Greg Wettstein wrote on 12/03/2014 12:46 PM:
>>> Secondly, Vlad, we have been running additional testing for the last
>>> two days and we have logs from the SCST core which I am including
>>> below which suggests that the SCST core target code excessively stalls
>>> or mishandles an ABORT while processing a NEXUS_LOSS_SESS TMF.
>>> Regardless of your feelings about the target driver code in the kernel
>>> we need to make sure there is not some subtle regression in the core
>>> SCST code paths during TMF processing.
>>
>> I don't see any problem on the SCST core level in the logs.
> 
> Fair enough, thanks for taking a look.
> 
> I though it was somewhat strange to see deferred ABORT's on I/O being
> done to RAM based block devices as there is little or no I/O latency.
> In our testing, this regression always occurs on TMF function 6
> processing and this was also the case in Marc's report. The comment
> that one of the other posters made that this was secondary to slow
> backstorage didn't match the characteristics of our test environment.

For TM processing backend and frontend (target) sides are equal, so the longest side
processing is what that defines your TM processing time.

Vlad

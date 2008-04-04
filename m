From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Fri, 4 Apr 2008 09:21:28 +0200
Message-ID: <20080404092128.e5ae33a2.taeuber@bbaw.de>
References: <20080331150434.a3fb336b.taeuber@bbaw.de>
	<20080403123107.71d82746.taeuber@bbaw.de>
	<200804031313.22257.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:37089 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349AbYDDHUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2008 03:20:52 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 9B7C84A8076
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2008 09:20:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 5F011937CE
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2008 09:20:49 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 0B426937C1
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2008 09:20:42 +0200 (CEST)
In-Reply-To: <200804031313.22257.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hallo Bernd,

Bernd Schubert <bs@q-leap.de> schrieb:
> Well, from my point of view linux-scsi is by far to quiet in case of errors. I 
> have patches for 2.6.22 to improve this situation and the error handler in 
> general, but presently don't have the time to clean it up and to push it 
> upstream.
> 
> If you would be willing to use 2.6.22 + my scsi patches we would at least find 
> out which scsi commands fail.

I could try this. But it is also poosible that there where some more messages in the log, because I only grepped for (scsi|mpt).
 
> Eric also did sent me a more recent version of the MPT driver, it also might 
> be worth to try this version. It fixed a really troublesome mpt-scsi bug for 
> us, but I don't know how well it works for SAS.

As it could be a solution I would try this too, because I have to solve this issue as early as possible.

Seems my choice for an LSI SAS HBA might have not been the best one.
 
> Cheers,
> Bernd

Greetings
Lars

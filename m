From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Wed, 03 Dec 2014 20:59:47 -0800
Message-ID: <547FEA43.1000007@vlnb.net>
References: <201412032046.sB3Kkx7l028625@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:59556 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaLDFAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 00:00:01 -0500
In-Reply-To: <201412032046.sB3Kkx7l028625@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com, Duane Grigsby <duane.grigsby@qlogic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Dr. Greg Wettstein wrote on 12/03/2014 12:46 PM:
> Secondly, Vlad, we have been running additional testing for the last
> two days and we have logs from the SCST core which I am including
> below which suggests that the SCST core target code excessively stalls
> or mishandles an ABORT while processing a NEXUS_LOSS_SESS TMF.
> Regardless of your feelings about the target driver code in the kernel
> we need to make sure there is not some subtle regression in the core
> SCST code paths during TMF processing.

I don't see any problem on the SCST core level in the logs.

Vlad

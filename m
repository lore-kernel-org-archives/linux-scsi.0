From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: Report
Date: Thu, 17 Aug 2006 22:57:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0608141837430.5437@poirot.grange>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
 <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
 <44D0BC2F.3030700@annessi.at> <Pine.LNX.4.60.0608022348570.12263@poirot.grange>
 <44D13418.2000005@annessi.at> <Pine.LNX.4.60.0608092315060.3728@poirot.grange>
 <44DF70D4.7030504@annessi.at> <Pine.LNX.4.60.0608132129120.3508@poirot.grange>
 <44E0905E.1000003@annessi.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:31633 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932265AbWHQU5Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 16:57:25 -0400
In-Reply-To: <44E0905E.1000003@annessi.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Annessi <robert@annessi.at>
Cc: linux-scsi@vger.kernel.org

On Mon, 14 Aug 2006, Robert Annessi wrote:

> dc395x: inconsistent counters: FIFOCNT 64, SCSICNT 16777214, left 16777215, wide

Yes, I see, indeed it is the correct patch and my suspicion from the last 
message was correct: SCSICNT is indeed 0xfffffe, and I have no idea what 
this means without docs, sorry. It doesn't look right, but not being able 
to reproduce the problem myself it would be a waste of your and my time 
and internet bandwidth trying to debug it.

Thanks
Guennadi
---
Guennadi Liakhovetski

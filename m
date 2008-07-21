From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC, PATCH v2] SCSI tape: MTIOCSENSE ioctl to return the
	sense data from errors
Date: Mon, 21 Jul 2008 11:30:40 -0500
Message-ID: <1216657840.3433.38.camel@localhost.localdomain>
References: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>
	 <alpine.LNX.1.10.0807131723510.16437@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42781 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbYGUQao (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2008 12:30:44 -0400
In-Reply-To: <alpine.LNX.1.10.0807131723510.16437@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, Arne Wiebalck <arne.wiebalck@cern.ch>

On Sun, 2008-07-13 at 17:24 +0300, Kai Makisara wrote:
> Here is the second version of the proposed MTIOCSENSE patch. The changes from
> the first version are:
> 
> 1. The command descriptor block (up to 16 bytes) is included in the
> result. The cost is small but the exact command can be useful in
> interpretation of the sense data.
> 
> 2. The residual from the HBA is included in the returned data.
> 
> 3. Randy's documentation fix.
> 
> 4. Computation of the length field uses also the additional length field in
> the sense data.
> 
> The stsense utility at URL http://www.kolumbus.fi/kai.makisara/st.html has 
> been updated to use the new ioctl definition.
> 
> The patch below this text applies to 2.6.26-rc9 plus the two bug fixes I have
> sent to linux-scsi (applies with offsets without these fixes).

You listed this as an RFC, so I haven't done anything with it but if you
want this in for 2.6.27 you'd better change that to a proper PATCH
before the merge window closes.

James



From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [2.6 patch] SCSI: possible cleanups
Date: Tue, 01 Mar 2005 09:40:48 -0500
Message-ID: <42247EF0.9000404@adaptec.com>
References: <20050228213159.GO4021@stusta.de> <4224245E.6090503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:26011 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261927AbVCAOk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 09:40:56 -0500
In-Reply-To: <4224245E.6090503@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Adrian Bunk <bunk@stusta.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/01/05 03:14, Douglas Gilbert wrote:
>>   - scsi_error.c: scsi_normalize_sense
> 
> 
> I introduced scsi_normalize_sense() recently, Christoph H.
> proposed it should be static but Luben Tuikov (aic7xxx
> maintainer) said he wished to use it in the future.
> Hence it was left global.

Hi guys,

I think the idea of normalized sense is very good.
Basically the question is if LLDD would submit normalized
sense to SCSI Core or whether they would submit a pointer
to raw sense data as returned by the device and let SCSI
Core decipher it.

If the former, then it should be global, if the latter then
it should be static to SCSI Core.

	Luben

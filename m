From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 16 Feb 2010 14:46:42 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002161445590.4986@uplift.swm.pp.se>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <19942.87.210.74.220.1266327794.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:55041 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab0BPNqn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 08:46:43 -0500
In-Reply-To: <19942.87.210.74.220.1266327794.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <caspar@ketsers.dhs.org>
Cc: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 16 Feb 2010, Caspar Smit wrote:

> Hi Srinivas,
>
> Can this patch be combined with the november patches by Andy Yan?
>
> I patched the 2.6.32.2 kernel with patch 1,2,3,4,5,6 (NOT 7) from the
> november patches and now if I try to apply this patch it gives numerous
> errors.
>
> Do I need to unpatch any of them or can you create a combined patch or is
> this already a combined patch including the november patches?

This patch is for a stock 2.6.32.x kernel (at least that's how I tested 
it).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

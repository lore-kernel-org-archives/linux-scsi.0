From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 16 Feb 2010 14:47:52 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:58819 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab0BPNrx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 08:47:53 -0500
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>

On Tue, 16 Feb 2010, Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech wrote:

> From: Srinivas <satyasrinivasp@hcl.in>
> Date: Mon, 15 Feb 2010
> Subject: [PATCH]: Fix for hot plug handling and IO issues.
> 	Added code for handling of hot-plugging drives and tape issues.
>
> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>

Tested-by: Mikael Abrahamsson <swmike@swm.pp.se>

(If this tag is valid, couldn't really confirm).

Anyhow, this patch is a huge step up from the stock 2.6.32 kernel, so I'd 
like to see this included in the next stable rebuild.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

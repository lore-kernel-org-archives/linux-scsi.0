Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE36261595;
	Mon,  7 Jul 2025 09:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751880658; cv=none; b=o77szX55WAB9dZYAKMRMaF9Anz/0+d9IelLIwhNMHvIp1rXVtXxdTn8VykhFpAxvmSSlvur6QRyMuGtidcuvoDpkzJcC9l6coIWlF6Ui5h4kTeNf2YrPjqrpuk5ts42TXDmCTEA4W0Jj1mv5rBTQu94h5YXijlKxhi+LXQGh/8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751880658; c=relaxed/simple;
	bh=K7JrZyeJr0fA5qvgVppFfTlATF6bTQeb6h9RB+P87Gg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZpV388u9AZ9eYXaUbscG2+7t0OZjMFzQGUqRB5hOpN83simWL1uh98m9+qEYYM8Ct2LMH3cNHgFQLRpRULjVlizmj8etiXVeflPF06ypdCWB28KI87PlDExY2NYGAiXBU2g4ITA7gEdD3XS25Odpm4t6UgmjSKEhuozbioKGmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=IpmlQ/6Y; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=F4yAYkmp; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="IpmlQ/6Y";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="F4yAYkmp"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id 9AD93E000F;
	Mon,  7 Jul 2025 12:22:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 9AD93E000F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1751880179; bh=mIH/6wS9UXcfc/G5kQA6nEGBfRYFEIAVr3D/v7LsmH0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=IpmlQ/6Yi7Q87gFnCka2jUtxoCajLjGA5tmwk/jnk0r72oR7bf/fla0GnIbwIwYoP
	 113nYaZgG/s53XUNFp0Oi8zgxuEUnUqPdnCLMivDdNvxgOT7e83MDWsY2LtG5MRMUN
	 OLJc9PsgpyZnq/lrrbRgqf/zt/MbUu+WEftLN+hA2DL/KNCQKTlnOTvie/rkcZX+Ty
	 HsLH4PPcK0Tx9H4sIRPFYhkzt2ta/1LiU0JSyuW4tpEnsvaCw1GnsHLuPToBSxtkDv
	 Eq+Rco9/RD4/n+zopq5htdbCK+CcdVCXRQcJnFDV4skK9eEsU8FYrHsH/LkvgHdbaq
	 VkCamXOJcEabA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1751880179; bh=mIH/6wS9UXcfc/G5kQA6nEGBfRYFEIAVr3D/v7LsmH0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=F4yAYkmpGTWsKIcSXy1wE8i22yUpPcRE+rdaQwnNKAvslvgJH8dnPeIDP7WqKLmz+
	 KXc4vsqurzIdS5Pd3iDG8udZr8utU6/1CS9pMyHfgOr3pMVAJXH5x+3UxiQuObpfHu
	 z2Qh1j355o6DlZLbZ9PdU/shgFx+dELqRzAJKv7MwKyfs1kYwC3Wl1WHAopX+1ml2k
	 F1/Iu/MTgCENqMwwgBOkWRuoe5a/dCJ375vu2VPPAE/TVyQt/hAZsIkNphLAssTISI
	 WWWYNvyrBUTBMFC2iNmxbiVGJQr04IoAcwh3cbZt2sc66eRXLzxD9pHeDjHdNOJtmg
	 Vt3+3WeGwxVbg==
Received: from T-EXCH-07.corp.yadro.com (T-EXCH-07.corp.yadro.com [172.17.11.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Mon,  7 Jul 2025 12:22:57 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (172.17.11.143) by
 T-EXCH-07.corp.yadro.com (172.17.11.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 7 Jul 2025 12:22:56 +0300
Received: from yadro.com (172.17.34.55) by T-EXCH-12.corp.yadro.com
 (172.17.11.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 7 Jul
 2025 12:22:56 +0300
Date: Mon, 7 Jul 2025 12:22:59 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Maurizio Lombardi <mlombard@redhat.com>
CC: <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
	<linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<mlombard@bsdbackstore.eu>
Subject: Re: [PATCH V2] target: generate correct string identifiers for PR
 OUT transport IDs
Message-ID: <20250707092259.GA12562@yadro.com>
References: <20250703081224.115865-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250703081224.115865-1-mlombard@redhat.com>
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 T-EXCH-12.corp.yadro.com (172.17.11.143)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/07/07 01:19:00 #27623336
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Thu, Jul 03, 2025 at 10:12:24AM +0200, Maurizio Lombardi wrote:
> 
> Fix target_parse_pr_out_transport_id() to
> return a string representing the transport ID
> in a human-readable format (e.g., naa.xxxxxxxx...)
> for various SCSI protocol types (SAS, FCP, SRP, SBP).
> 
> Previously, the function returned a pointer to the raw binary buffer,
> which was incorrectly compared against human-readable strings,
> causing comparisons to fail.
> Now, the function writes a properly formatted string into a
> buffer provided by the caller.
> The output format depends on the transport protocol:
> 
> * SAS: 64-bit identifier, "naa." prefix.
> * FCP: 64-bit identifier, colon separated values.
> * SBP: 64-bit identifier, no prefix.
> * SRP: 128-bit identifier, "0x" prefix.
> * iSCSI: IQN string.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> 
> v2: Fix the prefixes, using Dmitry Bogdanov's patch as a reference.
>     target_parse_pr_out_transport_id() runs in atomic context
>     because it's called in a spin_lock() protected section,
>     therefore I rewrote the patch to avoid using kasprintf().
> 
>  drivers/target/target_core_fabric_lib.c | 63 +++++++++++++++++++------
>  drivers/target/target_core_internal.h   |  4 +-
>  drivers/target/target_core_pr.c         | 18 +++----
>  3 files changed, 60 insertions(+), 25 deletions(-)
> 

Revived-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

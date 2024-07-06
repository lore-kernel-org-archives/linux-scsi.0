Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F181C383A9;
	Sat,  6 Jul 2024 10:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720260542; cv=none; b=TJZTNFiys4PrGGLw5MHe9HMdtJfsdmY0SlTCFgnj5LHQicn1QTsL06XuUBLxNoaMLm4HSA/baBMtOEfj+bY7vXolSLo9i6G1n4OZUQc5VhwEsIx6oyYe2phSsRHiivN0B/K0xc9pD+Df87U1bnQ7bBEyhJcuM34YcR7lztnrH+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720260542; c=relaxed/simple;
	bh=XvW8juf0kHjQpPvi8KtVoqpDIf/+5hM2n1xhapuuHIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SusgDJD8CMzBo0+6uG6JiNFBXtN8piPIiGj1LZ58NqGqnrwSuaGnwx/0zgvwQ3sK+UrhSztLNB4y7hSD+MduQobEZMV3/Ki5nhUaPysk/i0jswIEpI85HfsXb21uVm44Csgk/G5FDA781y5AXPEaRVYSJcfCzEv2DZ1ANISOKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV8ofKEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV8ofKEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B435C2BD10;
	Sat,  6 Jul 2024 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720260541;
	bh=XvW8juf0kHjQpPvi8KtVoqpDIf/+5hM2n1xhapuuHIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IV8ofKEk1l6/D+h65iNArVYllWxjetpkD7fLgWwxoYPrxfFxvmqMCigOGi2FhJbZq
	 PwQGESybBjGVBHcMDkuxP1Bze1vUtVmrCqHPlov6T7uE6D77IXe1sGCErJL2QzN1nO
	 iFFVE5EqOXgpSOnIdYc3V+wj0TI2LdcbEth1mT5U=
Date: Sat, 6 Jul 2024 12:08:58 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: "oneukum@suse.com" <oneukum@suse.com>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH v2 2/2] scsi: usb: uas: Implement the new shutdown
 callback
Message-ID: <2024070636-finalize-chop-f98a@gregkh>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
 <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
 <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>

On Sat, Jul 06, 2024 at 10:01:38AM +0000, Aditya Garg wrote:
> From: Kerem Karabay <kekrby@gmail.com>
> 
> This patch implements the new shutdown callback method added to
> usb_driver on the UAS driver.
> 
> Signed-off-by: Kerem Karabay <kekrby@gmail.com>
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
>  drivers/usb/storage/uas.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Why the "scsi:" on the subject line?  This is not that directory :(


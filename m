Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFCC5695;
	Sat,  6 Jul 2024 08:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720253597; cv=none; b=Nj9jQlfOnjyp1tOmRN7ynmat0XVwFjGwNBagNByh8jz6UMCux/j0W/aVp84jx4I0tBl2fWLmaZN1erSTuQ9PmOFkhkKW2hAhcDfg3cUcT0S7DK+Z+p1XllXtuB+nL/Vemck8FFGQuBv69iuoyNZWa8VodvkOSH2Cm94FmnE6YyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720253597; c=relaxed/simple;
	bh=VD/r4HnloDiHglxBi5eaUyYZytODT9d7ORdzPE63IoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqlqdAyvThYbtOnFJX0WGyVTYhetiEwg+4x4oq1zX358PqheFqvznAcIcKfvXbaLDEAxXklOM6sB4aD7gdRfGOFV7eAORqkns2OSVY/8jtSk3DO0oU9/XPNC4xn5fNimHL2c73Mls1FpgJMJtPPcDqMkfFPdq7ObvJJAmrSOKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0QMAx4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0QMAx4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEBBC2BD10;
	Sat,  6 Jul 2024 08:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720253597;
	bh=VD/r4HnloDiHglxBi5eaUyYZytODT9d7ORdzPE63IoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l0QMAx4wQi6KNt3rKtTiG8l2zOEgcyx6in5FX3f8sMShPI7FSqqm0IIEk/H4qx9qE
	 q04pxTgm5ay/lDF3Qr69E6SvK6zm0Z16e1zqsmv1KBLpujjgWl4CFv8cAaIAbv5zz1
	 igEd3+EtciE+C6kENGsdvrGvhRYms3OiuqJWEQIc=
Date: Sat, 6 Jul 2024 10:13:13 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: "oneukum@suse.com" <oneukum@suse.com>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Message-ID: <2024070649-nuzzle-movable-f383@gregkh>
References: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>

On Fri, Jul 05, 2024 at 11:21:06AM +0000, Aditya Garg wrote:
> From: Kerem Karabay <kekrby@gmail.com>
> 
> This simplifies running code on shutdown for USB drivers.
> 

Sorry, but this does not explain why this is needed at all :(

Where did this change come from?  What problem does it solve?  Why
should we take it?

I think I know the answers to these questions, but you need to document
it here as to why it is needed (please read the kernel documentation for
how to write a good changelog text and subject line.)

thanks,

greg k-h

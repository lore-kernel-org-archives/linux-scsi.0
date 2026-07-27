Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3844B429030;
	Mon, 27 Jul 2026 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173264; cv=none; b=EN5LMRIEgfd3IqCEErFvQLfMuZ816slnwGGV9vW8A7hnQNa7Vb1LfCEmnJGHnRtziVEPJUQM1j29pdNes7g/DB2dGgBd6vR3qIzacl9HXFIkPTcS4612C/BQsivA3C2XFK/PHNv0wZrWD/sPkE5SBdZ5EGAaGjsDHVL9UHL8VN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173264; c=relaxed/simple;
	bh=GjVZprBRyO1VGatYx+N57UIz1RvU9K5HtOfvbaTjGgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dw+SnmfflHie6xq3JdbsSgjpykYkzlMEuQQqZhkvO0Voh9ThuZlAgITebjmp9BFjdNPiAvrP1d8lkddPMB328YtQaX7L+fPGFAgZAKEQtKbGv+6RNAD3bg7YhW5CVzFq8rsW7BNbo6ly4DzjK0FnvTGcXD/Tz5juBiRv6wQnM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a0LidlWP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a0LidlWP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h85Bt6NL1zlfwHP;
	Mon, 27 Jul 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785173252; x=1787765253; bh=GjVZprBRyO1VGatYx+N57UIz
	1RvU9K5HtOfvbaTjGgM=; b=a0LidlWPiFB8okIwUGQpY6d1SAHYEh3kOz86mULm
	2W/cLkXbaaIxPnpPKHr3tCy5POkLX0ve+0DC5tYR6iYkRuO5rQEdeCtou26QwdPn
	ZYBvdeDr7cePeZsfpwBSbcz4Uz+Ck7m/eLN9Xl5X1PiZ1z8UWZNl0EUk14W3g3i9
	NOO8OTnTGbqIIhaCRLnx99oiP1K6R+MFxxMh+f1Z5gx9fL7yddfaYnKbZ4mGi7Yd
	mDMswnKStcEaee/QbW5SvTG0gOgPkVmWQzXWULfefjxFkKqofNXdr5rwGNKhO5/T
	RAnZfeZK9QbvI7MrNIV80w+vz8iOIFUGWIfrx09nzNdAJw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zGwJDTIUXCOp; Mon, 27 Jul 2026 17:27:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h85Bp6MMFzlfvq8;
	Mon, 27 Jul 2026 17:27:30 +0000 (UTC)
Message-ID: <66c3cdc0-c3a4-4fd2-a25c-b71c98e525af@acm.org>
Date: Mon, 27 Jul 2026 10:27:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
To: sashiko-reviews@lists.linux.dev, Yixun Lan <dlan@kernel.org>
Cc: devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org,
 conor+dt@kernel.org
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <20260725-08-k3-ufs-support-v2-2-45036a2a2418@kernel.org>
 <20260725104848.971611F000E9@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260725104848.971611F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/26 3:48 AM, sashiko-bot@kernel.org wrote:
> Does using the bitwise OR operator here corrupt the error codes?

Please review the Sashiko feedback. I think at least the above is easy
to address.

Thanks,

Bart.

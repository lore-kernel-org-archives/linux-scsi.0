Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AA2230997;
	Tue, 15 Jul 2025 08:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566501; cv=none; b=mEZRfkeT6PkI0Q41AVB/l+PdDYZkpoWHCc6cDfTIny7w9GXn4QBOdpSoqC3Lf3Ns1nWXkkxxUNwCpuXElJixSTYnB17j9CGRTakDkhp2AsizUlgkrnZMAS2hprlrZuxz3UbjHX1eYvchEuuUt8rszaKsPrABOJVS6QzLesC4ioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566501; c=relaxed/simple;
	bh=S6NHiSBLhIR3DYKmf6KEc9Y6Sel+6UdtVm9LhNemEb4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=td6mXwUH6Jad1IuUevmy65Zo2h962fQIPiF0XvUdpqvSCmXEncM+9Q6TDeKpNUFknLlgAnUMT+xRN085wNjCxQJXuKXCNtwqsNBl2AXF/jB+zX+ZmZ/OK111IuH0ON3SFjjE8acVquB9B73WEj/cBG4co88zlhCAdzONhP0gsQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=yh5SjI9E; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="yh5SjI9E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1752566185; bh=UPFN4iCrljSwXOyLIxdudLAgMwjA8757pjLDY2iNOls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yh5SjI9EGpBbWlPC1bebp5fi4mhSLZjv1Wgxs16o4n3jnn3FjZZ8aMMb+T7u/Ppmi
	 2pCdhAlo5Cscshhf2O8q7YhQoo/3KamOOIzkpuXGu2SD+YvSJpymkM8Th4ehe4qqxX
	 RxDPMfIBOg8vC/Ffiv+fEkBTNCRsKkjdUygs3d8s=
Received: from VM-222-126-tencentos.localdomain ([14.22.11.162])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id E1682E4F; Tue, 15 Jul 2025 15:56:22 +0800
X-QQ-mid: xmsmtpt1752566182tlmc1gbov
Message-ID: <tencent_88DDBC2334BBA2C8A4C1E122DE62F8AB250A@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GagF51JIOmPZtChli4QwYBGAqkJKqa/10a3iGlzj/46J9hj2rt3
	 3vXDUtC5q9unuIr+vi6B9uNiWxpOn2szT1MoK3VnvSjULksId/A4vhJPb0QmgL/ncaWqcVmJeZJG
	 isb0Vin5dS5h7B5COcIY2KC/yHw4ssrUwcLwo+QfmOLCaRSJeJOHc2IDZmm/zBAp8P3+SSn366Aa
	 SdpqHPF2u3tSn1NW3F01p97lzuFxWWEIPQbpy6eKboG0vl1ryN9OHnbdbfTxnOz2jW6zJxtI8hSk
	 0CFNSAeSii6EoMln6PxTcoQUuF2PNfyZ6ge13l/j/hlHj14i9CcYIwneoTeElpYjyA39lbFBhv+U
	 fXd1M5eQ+PPNvyHimhLjHvXIluxc3BzyBRMGvRhr8XYbPll6JbY4wrHxu7W2swAy5mKzosTxQhNA
	 OmBzhOdCFNb8MLDGDhLwV5Qh3K/9DDaGpjuqrHnG69Tyl38UaMQRdGcxr3PPGMTRrs8vtsUQu4j6
	 XHs3bepgqVq8f6e9o+Q20joxY+o9ej9bHFNYQcggmxSCGPfI29/FZcvaStsPsfQ3AkGUkQcHmK5+
	 /VOku406vF46YZtcW0P6SgQ2fGv0N7Zdxx2NZ9WBdFeK0Pq1ukRNnul8xy51+QvQ/3JV7lWpygJG
	 73AEJisUTX8hRk/UF+Jnd5uEF2soB3zI7JHBW5rjjcpNF2pi/dPows9RbZ2xFHnajbDOFmZaw8mw
	 uxO+729fhlBpWxmtRQr+9O0y+MrnQ78uMeiKVDfCvaMlk3erCrofTMbu5X7Iovgfrlob8BJXgIOR
	 mutdAwNdZirCVHWq5tF1EOB47n4ejnatBUyI6AscZbtWQux2aoTIxa39oZAcWc/qdMPSbzcdAkf5
	 8FZWIv9oxagUPijOfKEqofjfHwMbBE7wGHE3/LLMNDskB7aahQFV33Or12yMWY884rGbgOAni1S8
	 y2booDPnMWwcMrpRt1YLUHXeb7BZj+5LTNQiowg/HjQYEh+ArEbu9f6APXi7oEc5L+lAVFS944op
	 45kEMfq4GN1nwQjSX8lsjUl+EsN1q1qoslJbBb414nO22N84xEIgD5VHHZOe4=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: jackysliu <1972843537@qq.com>
To: 1972843537@qq.com
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH v2] usb: gadget: functioni: Fix a oob problem in rndis
Date: Tue, 15 Jul 2025 15:56:17 +0800
X-OQ-MSGID: <20250715075617.3120827-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
References: <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 11 2025 08:51:30 +0200, greg k-h wrote:

>Yes, and then look to see what buf_len (not buflen) in
>gen_ndis_set_resp() is used for.  I'll wait... :)
Oh,my bad.It seem that buf_len will only be used for some debugging code..

>What tool generated this static analysis?  You always have to mention
>that as per our development rules.
The vulnerability is found by  is found by Wukong-Agent, a code security AI agent,
 through static code analysis.But It seems that this is a false positive..

And what qemu setup did you use to test this?  That would be helpful to
know so that I can verify it on my end.

I'll add some web-usb device to test this model.But seems that I went into a wrong way.

Thanks

Siyang Liu


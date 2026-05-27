Received: from mail.wtlc.com.tw (mail.wtlc.com.tw [220.130.222.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B2336728F
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.130.222.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779920409; cv=none; b=tNbcc1f7xdUtNu2csp2Jrakg+qddsbpqgZ3jiU+Tc8q24vj0QWjU2kkJkHDtddkuyQREUcHF9YiSGMly+CPORcgsQsQbEUpEyj24w8EDM4CeyNpOwRlPNknnPUYsf70w7SjuGDbMsNZkE/AbRTN2ayIYdtg1mWxviEK8YnacGN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779920409; c=relaxed/simple;
	bh=LgxS7OWn5hlGE+z98YMrYTONUnz3nA6U816PuhUy1hA=;
	h=MIME-Version:Date:Message-ID:Content-Type:Subject:From:To; b=okaiw2peS6VWCr/2bFjgClekHuY945vun4i/he62+6jkinSEdirIH6u3p8bFgwfhQc9ei6hvqm9bn9TXTkFHd4AUi/NoXpenil5ikdZADtrRZ92Tgp9A/HUzkNNAVgUBLzzdIg6V6U22JUhM5fhMk9sAUDMf573KSB2OPATOsaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wtlc.com.tw; spf=pass smtp.mailfrom=wtlc.com.tw; dkim=fail (0-bit key) header.d=wtlc.com.tw header.i=@wtlc.com.tw header.b=I6b19uEZ reason="key not found in DNS"; arc=none smtp.client-ip=220.130.222.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wtlc.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wtlc.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=wtlc.com.tw header.i=@wtlc.com.tw header.b="I6b19uEZ"
Received: from localhost (localhost [127.0.0.1])
	by mail.wtlc.com.tw (Postfix) with ESMTP id 9E3A81A1BD1
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:14:11 +0800 (CST)
Received: from mail.wtlc.com.tw ([127.0.0.1])
	by localhost (mail.wtlc.com.tw [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id YdKbpx3sGinR for <linux-scsi@vger.kernel.org>;
	Thu, 28 May 2026 06:14:11 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
	by mail.wtlc.com.tw (Postfix) with ESMTP id 377CF1A1BCF
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:14:11 +0800 (CST)
DKIM-Filter: OpenDKIM Filter v2.9.2 mail.wtlc.com.tw 377CF1A1BCF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wtlc.com.tw;
	s=default; t=1779920051;
	bh=LgxS7OWn5hlGE+z98YMrYTONUnz3nA6U816PuhUy1hA=;
	h=MIME-Version:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:Subject:From:Reply-To:To;
	b=I6b19uEZarIVIw3ntUONt8BSwwoL2tyHnrptqhg1tHz+s4Xg8nJWtEarEa/7Zf5I+
	 7VXLBH5vogJMEc4azfUkIul4fqKASoOmiPYqK96dnyxOZMMGGBUM1PKzbwunNYpcah
	 tLCzPbDw3M2vlJwhbgm1l/P4q+g+MqsRo48oEWvE=
X-Virus-Scanned: amavisd-new at wtlc.com.tw
Received: from mail.wtlc.com.tw ([127.0.0.1])
	by localhost (mail.wtlc.com.tw [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id A4ieYLr98Hoa for <linux-scsi@vger.kernel.org>;
	Thu, 28 May 2026 06:14:11 +0800 (CST)
Received: from DESKTOP-F55A126 (unknown [154.160.53.5])
	by mail.wtlc.com.tw (Postfix) with ESMTPSA id A7E201A1BCC
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:14:10 +0800 (CST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 27 May 2026 22:15:11 +0000
Message-ID: <4A05F7E076B3F839DDA45868379D5CCDCF62833C@DESKTOP0F55A126>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Priority: 3 (Normal)
Subject: Ich bin Dr. Noah.
From: "Dr. Noah Jang" <cccjohn@wtlc.com.tw>
Reply-To: drnoahjang@hotmail.com
To: linux-scsi@vger.kernel.org

Wir m=C3=BCssen reden.

Received: from mail.fastemail60.com (mail.fastemail60.com [102.222.20.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C5EAC7
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=102.222.20.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799880; cv=none; b=GNGRcAUPE8YdoRtSgixnd7zxoSxG+V4m3Ff+0RbKEUZddW5Lvvc5pKoOU188oElZN1PixsAymPs4HeWnuJtUTOFalnfGA2+mbSwolIekU2mDek3Sc/p4JVi522egytTAhYwFCZ3wC/I45UP+WKzeoiEbgQGnxTLZqkY5j2oRqyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799880; c=relaxed/simple;
	bh=0kM12Ki2v7eI61I1WvQrX7nQw+DKE1uiGUA45uahRZc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PJ93eqDrtl4OP4uzEhrjstMU/v+XEtT8r5NAGa9jIFtIB8zgZ1bCeIJYHzCMPmx6N3Di3Mby1pmT0DRJkrQYP1zFdINTNn1imvUFvWtHLazp4ZuBo+VuXCjxV/Bqmx2VkOjwPaMPbaP8R/SYGu26P8UlUNA7XzG9yzpHuKzRClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fastemail60.com; spf=none smtp.mailfrom=fastemail60.com; dkim=pass (2048-bit key) header.d=fastemail60.com header.i=@fastemail60.com header.b=jFGPe4+x; arc=none smtp.client-ip=102.222.20.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fastemail60.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fastemail60.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastemail60.com header.i=@fastemail60.com header.b="jFGPe4+x"
Received: from fastemail60.com (unknown [194.156.79.202])
	by mail.fastemail60.com (Postfix) with ESMTPA id 049DE87BDFE
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 15:55:20 +0200 (SAST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.fastemail60.com 049DE87BDFE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastemail60.com;
	s=202501; t=1746798922;
	bh=0kM12Ki2v7eI61I1WvQrX7nQw+DKE1uiGUA45uahRZc=;
	h=Reply-To:From:To:Subject:Date:From;
	b=jFGPe4+x/BaF48g2Rw6/3st2vx65mFWr55+EWrlMKNwhfIiKymIDcCy4AM2jsQ4y4
	 PxTbsezSRdYa9vWTR+Hebk5ELqAjpPKkN4aZ3ZG2rwL+3xsZVBU6TtGsyR5UoO4qdI
	 DAn4JxPYXpvOhd0dLgM71w+61juWBaa81npgFODTLhc9rM+nkyqrP1ccszbZp52LyL
	 crXh4AI1febNV+n2s5yQj+BqP7uVQzeliNfLQ/cJeEK7QpyVLIGEUpR1DufTGv65IU
	 UiR/XnBGjvV+ByOOUzCI4MkfNSN3lYw2/edKnw0XUOtERhPRMtOG0yhP4kFvatW3gB
	 kNIHkSR0vRagQ==
Reply-To: import@herragontradegroup.cz
From: Philip Burchett<info@fastemail60.com>
To: linux-scsi@vger.kernel.org
Subject: Inquiry
Date: 09 May 2025 09:55:20 -0400
Message-ID: <20250509095518.6AB25CA63A44B914@fastemail60.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (mail.fastemail60.com [0.0.0.0]); Fri, 09 May 2025 15:55:22 +0200 (SAST)

Greetings, Supplier.

Please give us your most recent catalog; we would want to order=20
from you.

I look forward to your feedback.


Philip Burchett

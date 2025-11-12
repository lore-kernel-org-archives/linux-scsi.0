Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24F328B73
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 13:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762954713; cv=none; b=lfvq4MEz/CPcItd1UHZXdCm9p+xX42YYaNCkX6v4Boc0u7TEtdoMCUAxS5N1d60C8BcQNeJfYGXc6VDzS/VKhRI82xclbvlLfF2gXpIcEiBlzTKikaNHhyuNLn6tzMlq1e4o4Hhd26iR0fXmv7qmiPWY9exg9PKqjs8ASbUTWdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762954713; c=relaxed/simple;
	bh=c72abcFKRuRpqoeiVcRjI7ELcItUM4ZdiLTZkEuaTEc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FakmDwOtPE2YJLVXYq8AsyUSimDFg89Q/qWCqg09oa7WiP54lB5j3XHtLL31znyCZh1zUUloxRgqBOSRv2BRPSPhi8P15OZw2KIh/gKUYqqS2gjOq2u0Ik8dijSwGcKDYz6gfoarBTQ0Ec0kEUc38Ds41s3eWnKAo9nUUPojI5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=l6LHGS8+; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="l6LHGS8+"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=c72abcFKRuRpqoeiVcRjI7ELcItUM4ZdiLTZkEuaTEc=;
	b=l6LHGS8+YM+xKyHSKmVgmKkNkQZgbZCRsqBL2yN/OtSLoHfbqYHFk93mPzREZrTDUrH9udTna
	IG8Qfdp608M9j1YBHQWhBoheE/mqcKhH5J8IXLMQQhSviYUdzb+wM7ZP51DIkO7C30fQhxLvZ9Q
	yt3uHT42g2XHZyqI6i6mdYA=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d64F64jmNzLlV6;
	Wed, 12 Nov 2025 21:36:42 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id DC6E31A016C;
	Wed, 12 Nov 2025 21:38:21 +0800 (CST)
Received: from DESKTOP-4VUP2L6.china.huawei.com (10.174.187.123) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 12 Nov 2025 21:38:21 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <bvanassche@acm.org>, <john.g.garry@oracle.com>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum value
Date: Wed, 12 Nov 2025 21:38:16 +0800
Message-ID: <20251112133816.343-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <be49d9df-2738-4864-839d-99f24d77a058@oracle.com>
References: <be49d9df-2738-4864-839d-99f24d77a058@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk500001.china.huawei.com (7.202.194.86)

> uh, I never thought that this thing actually was accepted=0D
Have you reviewed this commit before?=0D
You seem to think that this feature is not good.=0D
=0D
> Again I will ask - which of my changes are you referring to? Provide =0D
> commit ids, please.=0D
The email I am replying to now is the change.=0D
And the commit id: ac0fb4a55bde561c46fc7445642a722803176b33.=0D
=0D
=0D

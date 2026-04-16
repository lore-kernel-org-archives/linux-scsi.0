Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF3A13B58C
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 02:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776306723; cv=none; b=uK4eKqa+FKweuvaBNwMMMEpKP2ELeFUBPIg2IMm3Y2uZVLOh3YEuw2LXz+ziY7a+JfzMwk9g41khv2YTUvVaZkvQ065aOI8b2Lcdhi4QQq0mKbscw5pJa2Bsg+jB8EG0xVVODVe/nGOPK0h4yL3pWrTEkw/4fmZ36EVmVB7tNHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776306723; c=relaxed/simple;
	bh=LksDHZ1RqF5dT0TM0ril2pWkgDoY6j2Orq1gUZn8NPA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2cnqbI9WT8+fpP8uEw1He4AWe7gC6e4sTjV58WoVx8QS5EvMJp0UymGo52ikH3OtS4zhQcPydUPbkwd0pzYKdmrN3MttkLhYp5ORFKr8YJjWqLRT75qyAIvdqDuYS43obPWtg01EQHyJiSatp+8Mx+HtRyRPETIYPswNIJTnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=JLUld/Bg; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="JLUld/Bg"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vR3IxBqeYZYnkjgCUsvrGkSJshJxOVzoPva9OeduYdY=;
	b=JLUld/BgyDoSXe2fxZ6DqkwQpt78d2C1F4G8tooAeb1HrLWdqJgNrtcnHUhgFnDe39+xgRF0C
	PhVX3KMQHZvny/669M8CRCk2U5CmMng2RNL+zxljwqu98L/YtwKzsPAI6LR5VOQFlEFjWa6nxSa
	gQDIcWCV7DdoKWNYi4QF6rE=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fx21C1Lhmz1K9Wn;
	Thu, 16 Apr 2026 10:25:35 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D9C740562;
	Thu, 16 Apr 2026 10:31:51 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Apr 2026 10:31:50 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <john.g.garry@oracle.com>
CC: <bvanassche@acm.org>, <james.bottomley@hansenpartnership.com>,
	<jiangjianjun3@huawei.com>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>
Subject: Re: [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
Date: Thu, 16 Apr 2026 10:30:56 +0800
Message-ID: <20260416023056.3366514-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <53fcb929-2f19-4702-80f1-1aa059b308fb@oracle.com>
References: <53fcb929-2f19-4702-80f1-1aa059b308fb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk500001.china.huawei.com (7.202.194.86)

>> 
>> John,
>> 
>>> Can you please consider picking up the first 3 patches in this series?
>> 
>> Patches 1-3 applied to 6.20/scsi-staging, thanks!
>> 
>
>Thanks
>
>@JiangJianJun, can you please check the other patches?

Sorry for sending this email late.
That's great! I have checked the func, thanks!


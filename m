Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D6C197A93;
	Thu, 10 Oct 2024 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578043; cv=none; b=s1M5LTNksvUCswC7clv55W74UoOAwrVrwTJ5fKaTP0zD92EU3kTptU4iT5YnhiBfovE9GzXS/OWLvxleQaDcNRPEaJYA6ct6pXOT4b+9HStaHkmyypUodBGo2VPB110Ti7PNY4VH4QkW+98lcFR/ek1ohTtJKdpFekq2Cn3z+T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578043; c=relaxed/simple;
	bh=AqMThYWnxXN2dG5zO52+LCz6lhKNg5SlN1+Yyu1Qwqg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P+BTEuPfrAGbtw/HGqFkRO+uGyQud8sQz6Q4EN038pvIKDdEDbu7lhbzr0icKo/KTPhvyKllhxu3fu29kNH3RbWj55dx7wiluBAsbOrvO9IeIL1HrFRr4/w959pvX58+dSWPpoKBTY7j0FDeY5ue1d1ZO4wg+XfJNtUa78jBePE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=HK3SOQez; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=qNppMYo5; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="HK3SOQez";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="qNppMYo5"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com C29F0E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728578029; bh=SQi5Kp+ilhRmAcF2pNfJqX2VcEFC13qo8zhMMga7zW4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=HK3SOQezuYRMwTCul7R4vl/O5P58jjE18iYfIL0/vXzos5ZYnpQw+AAggzSefjJf+
	 pnWD1B3gd33Vwafz1zVzdQYZcc8285+CErWzfbqH7wgU7dnQU+HhHkeIBvlMUen0t+
	 brrg56OsNEIUMxAhkdkizSIqD7C/QatFYCQ1t+f/llm9ZjcgLQy0wmdRF2Ue7jodT4
	 e1zPWi+uw2QOWH5nhMRf/OatAJQrTbAQIFEpLRbqNzNNkAglw4Nla1EJORDoOMcVuW
	 3yk8R1b4f8R+lR1HtdFJelXY0rrKWww75gteUuwXyyGMxyZXHJX+PbsRV+NiXw16nm
	 yQoi/xaHYoI4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728578029; bh=SQi5Kp+ilhRmAcF2pNfJqX2VcEFC13qo8zhMMga7zW4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=qNppMYo5R8gAMRFfqBi6u2JtcBqmThis7HXbmuKqtGE3Z0zoRB3SjD3Tbgq+HZC7r
	 6MzmMY87DL6YrelrwgfJtEZdFZnmSU03Ja//2b4yRZJJ9W4VW4cgX84MMvO9nLV/z0
	 zQjUcsM7jtOQ/GiOuZPL8TRK5y8X4UsS1ppw5bQzkw+F3EjlUZGJt1SC2WSKt74dgF
	 ysQER8InSuhRdmPhZ2/wYYV1h9bu5jffJBWffbq1WxTc8in/+NjCJox1Z/pW7IArE4
	 yKHzALDzEIeKZKvPe02y+Iieg+5v99p2Vl8clKVhISTjivxXl6F/vwy5qHvr/iu5Se
	 mI9fiEiHCPB/Q==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v3 0/3] Fix bugs in qla2xxx driver
Date: Thu, 10 Oct 2024 19:32:33 +0300
Message-ID: <20241010163236.27969-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

This series of patches contains 3 separate changes that fix some bugs in
the qla2xxx driver.
---
v3:
- Fix build issue in patch 1
v2:
- Change a spinlock wrap to a WRITE_ONCE() in patch 1
- Add Reviewed-by tags on patches 2 and 3
---

Anastasia Kovaleva (3):
  scsi: qla2xxx: Drop starvation counter on success
  scsi: qla2xxx: Make target send correct LOGO
  scsi: qla2xxx: Remove incorrect trap

 drivers/scsi/qla2xxx/qla_iocb.c   | 11 +++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  4 ++++
 drivers/scsi/qla2xxx/qla_target.c | 16 +++++++---------
 3 files changed, 22 insertions(+), 9 deletions(-)

-- 
2.40.1


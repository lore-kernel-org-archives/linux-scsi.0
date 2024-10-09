Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C0C191F6D;
	Wed,  9 Oct 2024 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472668; cv=none; b=tgYtzyAgp8s7kuYiccMRLL9vT9ByhKVyMM0ta37sGs6shrQ86ZJOnGc2XlW/DsKNSEIcwZBR31zPImbTpu7++9CIQWJhYAI4DYkZ1XlS7BmlgCdPSLNve9O7TwI7zd9AB0ggXI0KBfBoO21EwcDh2XKmEIRnFa88EXQ3A1hPGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472668; c=relaxed/simple;
	bh=Lz0ftFsXhb5jJOCxFoVtj6wvWCrPk1YnXLs9cvkNDWU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fS1ZdpugckLVVO0VbaNVaf1OzjwmLZ0kMEKEnNTePglltuJup/5Gj9qEN1gZvwdYrGsfmz1hyvgwFniT211Jo2wRmywE0BWfmyQlgLAt6Fh98DVHA+A0uqktYilVykeSnwk+Y9FG9H5O+HA9zJKKNdLEmG568SDo9oJ+AHSfswE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=IH4HZife; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=gyNJZSQu; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="IH4HZife";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="gyNJZSQu"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 4CA9FE0010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728472661; bh=R907DmC1jjYrPDTem5g7CEoM/mYg6Iq8YV9QdrYYCxA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=IH4HZifep8H4+j9cDgUH2BkZOPX88XMOo36HQwsK0O7H2YvsDIdzFQM+1kDLqokXT
	 xt7HI+M5HZcTHX1aCC4JKD8mkkLhowAKGxeng+R6/vec5LmNwvcemtD/QPwu45Ad2Y
	 B3vRhtQs7gJNHbmiKqYbPzpBTjSA3bpNhROHqXicH9Jak8YGkyHtOVH7YbkxDptzNu
	 40rJsrWUKCCtGrgtmXJdr7naO9oUa2s8jcxf/BgZc0O3+TZ5+7c3HNDu6iIqruZBbd
	 YpenyJ/xpJueTJBX2z+8N32KJQPgKdctU6Bx5hMXKK1itFqf/qvV/GBVBz/6RWTlPf
	 DRfnJJu60sO7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728472661; bh=R907DmC1jjYrPDTem5g7CEoM/mYg6Iq8YV9QdrYYCxA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=gyNJZSQuhBr70Weh/OrKM+p68zZOrbVuOWo6eKyDaHe1AxcXiJ7LF3PA4szSEthhD
	 XFTt4S062VbjioJ7tt7k/UifJiq+u19FJcBxXgLfj2iOIzAquyBaoxH9a1pO0Jlk0t
	 QBkpm9phNSjNu0eNvWqC0y0U9uDRbGi/UFdTY2Si0KK6oJKeYNcCzDjhAmhYbD++WZ
	 lJYwPF1AC4dGienLhrgg0P7FTptxHxCsIRFza/390EMCSYjJwiXeuuQxkMBuofpJwR
	 rMfcUCZv/15TEEyAHJy0eE4sZ+6YPRsuQB4ctKgWmofgMcdRDZHZ8PhbcvQIF+6MHg
	 mgDszipZCe0rw==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@cavium.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v2 0/3] Fix bugs in qla2xxx driver
Date: Wed, 9 Oct 2024 14:16:51 +0300
Message-ID: <20241009111654.4697-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

This series of patches contains 3 separate changes that fix some bugs in
the qla2xxx driver.
---
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


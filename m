Received: from smtp.eurecom.fr (smtp.eurecom.fr [193.55.113.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E19F1A8F9B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.55.113.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130811; cv=none; b=FRWtLa7OfRNpTz3xIEMF9gk4bSRQTV/vXUrHHeoVU56jBhIvn9DKLnlg2aJnGdj3enez2eUZjr7ioIm7WlUeUxidpWOnvtwPT2tg4iuy106IjPZN1r1SJZiLTSYYwR6wU0f683l5bqPJKY25dobQf0d9AkezxDkny+wqUSywlsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130811; c=relaxed/simple;
	bh=bE67woybIAqRNhBwXqnAhULjpMMnRHa925PmhWXjMfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mKiqpQc/RrF1AWeWg4dAfJp/pGbrqzQMdtF3/x+hoEJXgewzyrJaclbHX1R+3gJfuuoni8Kr865r10mxlxA2TPPKuftko5O1/aHOPIYiF7FDNH7xsjSyiQ2roCKMKpufHzRQOw4HSd5RwcmUa1m6P2mzJEbJpXK56TkuTCAPEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr; spf=pass smtp.mailfrom=eurecom.fr; dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b=e6kSWUa9; arc=none smtp.client-ip=193.55.113.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b="e6kSWUa9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=eurecom.fr; i=@eurecom.fr; q=dns/txt; s=default;
  t=1734130807; x=1765666807;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bE67woybIAqRNhBwXqnAhULjpMMnRHa925PmhWXjMfA=;
  b=e6kSWUa9YCHqmw4YsbptKR+wH80YkbyJm9ZAuq8wjYk03QbhNSciXCDH
   cYOVYMvG3pjaxUEo1l0t9sg+eajjgMFuYk5VOSCIiGdSp2HrLMEgnmXjR
   C0gBJi2asGgrxT1H2l56f2jyJHXWRnepQKEYQlajUPLK40zUE8Mncle3+
   U=;
X-CSE-ConnectionGUID: zQ+RGg/vQn2T01akVuF79g==
X-CSE-MsgGUID: Hr30VNVhQ3CET0vIqShA8w==
X-IronPort-AV: E=Sophos;i="6.12,232,1728943200"; 
   d="scan'208";a="28179945"
Received: from waha.eurecom.fr (HELO smtps.eurecom.fr) ([10.3.2.236])
  by drago1i.eurecom.fr with ESMTP; 14 Dec 2024 00:00:05 +0100
Received: from localhost.localdomain (88-183-119-157.subs.proxad.net [88.183.119.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtps.eurecom.fr (Postfix) with ESMTPSA id 19F5E2C18;
	Sat, 14 Dec 2024 00:00:05 +0100 (CET)
From: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
To: linux-scsi@vger.kernel.org
Cc: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Subject: [PATCH 0/1] drivers/scsi: remove dead code
Date: Fri, 13 Dec 2024 23:57:28 +0100
Message-ID: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This patch clears out a dead code warning.

Thank you,

Link: https://scan7.scan.coverity.com/#/project-view/52745/11354?selectedIssue=1602240

Ariel Otilibili (1):
  drivers/scsi: remove dead code

 drivers/scsi/myrb.c | 2 --
 1 file changed, 2 deletions(-)

-- 
2.47.1


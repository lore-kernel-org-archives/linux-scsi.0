Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.3.219.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124111;
	b=AXGK+e54Rxbzn6ItBpf4DJI2hV3Sx2U46czeYJKjhJ/zKMu7/pJ9pjcBTP4b7laUs7bl
	 F8+AnIf++2312fieUC5lnxPKpqYolVvJD0IdNAtDLDoEqHQfgkGmchNtYnRDsPTPkRWwe
	 08R6F+aDBpCcis7GLayaT53cPOfsfedhbifv4vDiDaCrNh9Ja/YTHt/mEM/cv85NF+HXe
	 p9+I4Lmsknw7JmjGB+Y7x60tiP2lVIzNY0P5w9a6pitgf8QbiAnH6HQIXLm2TCQOANQ7G
	 v8IOmyEkUl9PIsySOCT7buUfDAPcZfxjbIf08ZzBMsMg/n8npSlAkdr109vY3b2zi3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124111;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-KSMG-AntiPhishing:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:X-KSMG-KATA-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=EoFSjHbCT0ntK/QpdldsUfHLOSdhKoC9v8cWfqZ7lD4=;
	b=W1AQ9g/7LsoBAZyWHdS6B+DT4iBANDZAMIFQUhnmsIZzGF15czM/g3x6zp6ga0XC1k+N
	 utLonnZzgeDmc9XTUAdEBLT0gL4ch0rOzSEtWKDWyM8U1cVTS35qslkcT/biMBo//FZ+z
	 KGCYBnBk7qfz19ejlfu+7mKZ+SwBUtDbsQ36O62aK5SDsDyUTyFNWDXNj4y9J6rh/MFbH
	 HEbPgJNa2WAqVzvZXxvU4uxsbvVxJd5v1pR04V6pSn5XahIzu0q2UBKtjdIHfx0iyl71L
	 k0IeSdDMeN5W+g0db2R32poxjIRxBUiK28EQvXkCXP73RVx1AX+b+Gl7NjUS/gQdFuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yadro.com;
	spf=pass smtp.mailfrom=yadro.com;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=Delm4Pa2;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=lV3t7RpP;
	arc=none smtp.remote-ip=195.3.219.148
Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D2E606A31A;
	Tue, 27 Oct 2026 18:01:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64D2E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=Delm4Pa2;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=lV3t7RpP
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 35CDC2001B;
	Tue, 27 Oct 2026 21:01:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 35CDC2001B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1793124097; bh=EoFSjHbCT0ntK/QpdldsUfHLOSdhKoC9v8cWfqZ7lD4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=Delm4Pa21HYL2LWgh63p0OEqnZYeUC/R/M8Q3p5ic1nXCt/fWHIbtX0DW5xIKQvxK
	 m/n/hGkHtQn3vP41pe7UCHxZFEoQkFnNONee19oUYqqIpTbMnuGKhc5iipRA8z3T0N
	 FBf+IYbh+bDa+1KH1MAhy4ELYoFRC6VsX/+0JCKrzyXJhasc6805NNbwiWdzJoj3lM
	 SW2G3PA0p5LCFnm6ji3d+/tasgsoYjoasnAAWXCZdPBLxvfdyK8V1B1Rk5qwW4Dvuj
	 UK+fqh31MOoP/FH8oTcbBaL6r6Motqtbvhe2ynyKjUE/H7+/vSyCSicfBNmsLawO+v
	 GXI04QmOiRuSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1793124097; bh=EoFSjHbCT0ntK/QpdldsUfHLOSdhKoC9v8cWfqZ7lD4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=lV3t7RpPa1fc/jLeJphb22IjU9Rbw41EPmUq6CsfIKww4D6LpM4SOxA3e91eHz+Va
	 Fj1+pZUQKiPI9v5BV2ZgEUXDm2ryE8mw5y+VRlQdgToG7WwBTUaecphiAflSCPOjH2
	 ERw6bTjMy0vF4qE/06LEZ3tdc5AGcUKsWNlVkJp5BEKdjWNAvIHUL9SZ0yc7JaiW7e
	 wWvcyFuloNqSRumkCgvO5BpDZPS3n+7m6HuL68qZ48bbh5Y/uFlu3yy2jt1L2LVqGi
	 6ee24v0RlDdNdnL1hVKZttUHQ7tlCTsGy7V0BZ3o4r8UKSP8BaqMDv8NVXGH6xegfg
	 ISYs4CdTDJrRw==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Tue, 27 Oct 2026 21:01:35 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.34.9.247) by
 RTM-EXCH-06.corp.yadro.com (10.34.9.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 21:01:37 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	<mlombard@redhat.com>, Laurence Oberman <loberman@redhat.com>,
	<target-devel@vger.kernel.org>
CC: <michael.christie@oracle.com>, <linux-scsi@vger.kernel.org>,
	<linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
Date: Tue, 27 Oct 2026 21:01:21 +0300
Message-ID: <20261027180123.13163-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/10/27 10:49:00 #28748526
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

ISCSI has some old leftovers in the code that prevents passing the aborted
command to the target core to make the actual abort. Such commands hang
until connection is closed.
So remove those leftovers.

Dmitry Bogdanov (2):
  Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
    commands"
  scsi: target: iscsi: fix hanging WRITE_PENDING commands

 drivers/target/iscsi/iscsi_target.c      | 19 -------------------
 drivers/target/iscsi/iscsi_target_erl1.c |  8 --------
 2 files changed, 27 deletions(-)

-- 
2.25.1


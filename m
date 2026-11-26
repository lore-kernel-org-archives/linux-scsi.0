Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795732370;
	b=GhtVWdgLHpqz1Nldzt7DCiNSDwIaS4O6/YI/2WE8q78hn7JI8afDufI3QO2SDg5n77hN
	 DqBiFig73wiQbAI955DuaGUSpqzxzk4ZndRAfnzQLtKuxpsbVrXmj1q3s4njr9Qx4ZO6E
	 X5YWpv1kkUHODjNv+EpkbYkwv2WXWesOyi5VdOKTXpCZ6LMsm+5b4nJqcoJocfpLFHjho
	 xZB7Nw+8CipvSPE55fWp7WsKfn9pdQb9yjKceP2EmvGtm6qXYq7LDCapmjbUoKYH9YBsC
	 dJhVom9OJW4fWX/HeVpqPhRxaXy1JHPS9uN82xNx3QhbtqTus5bd/zeIXuW3PvSNzvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795732370;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	bh=L8BgtXNBzYX1GjQ1VVae357SREfMavFxSODIa4qd32A=;
	b=TrvphVX43X43pSqLbtNHp7bSLcvvrPe3ox23tn3joNnNguojyI6VkceRyFq/AdeITmWN
	 b5NY4bdIlO7mC2vOZf9d9izunTk2xJA5r+7+tatfikjlnv+/Rv82Qx10qO63iaN5V7FPr
	 ReNlDHhOiEXUZDAvSAP6HHPbatNup/ATweejv6FiSwoD/enhTX2pDA+k7iAef7ZYJyJEj
	 dcweedhTbYry+NNuzJUB0+hlacW1Y+dAwCePVxvv/jjKUGQBykSZzIePW88nkrVYgKp/D
	 UnmdPClCnsN7GNHvzqkAltUJ5Hkip8O1qVYRyOSMhk8rQqCXCwmAyzh3Gx31s99IrrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b="Ljc/TmRO";
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=VR416GXq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.54
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243D7606A326;
	Thu, 26 Nov 2026 22:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 243D7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=Ljc/TmRO;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=VR416GXq
ARC-Seal: i=1; a=rsa-sha256; t=1795732359; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=gF3bMkcuhVsspSwtUBQSYQxk6l0miaY5mIAD+KkdExgRl4KexAMFfC1GCTvIckrb0t
    OS/nNkov9NPPwVUJmEb1vXgjrIQZjQIH8axxys7mpAENTGP4XWpbJ8GLwx2EP65QeArP
    x601Zh8kXwx+70YUzrWj7e/s9C6zDhPVjZpCQ2S3WVY1Uzz4AMomeuqqaIBexrzROMXr
    O1CnviablrCq4DNLy2fIF02UqjHXlOF7sa1yWUgUd1ZvnPzZ3aQAjKd0LqO0C/tGUVIm
    3ozDPwMCP4RRpbS3kgBNnij5BVPmeDwXTcCqu3EuVHMv4e01PIjOb+EFnlI4dZWebzgy
    2BeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1795732359;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=L8BgtXNBzYX1GjQ1VVae357SREfMavFxSODIa4qd32A=;
    b=rR9+wATxxIKklUQlRvWT2Fb8KnbBn4VhZb87SKGfSAsC6JoyM2TyMoPhzJb0Fl58S7
    bvh1cAu02d8Agy69YQ+CkHb+eP0Icf2amuREIYhuxlTtR6ynVyw+aJBXVoaESKzGeJ1J
    KNy8pA9rl43vKZ0Z+HkuMl6yK5h7iZoy6OrZMSB7E8ePsuEjFNxH83nz6zvnyd4qqCGi
    zl4TS3iUhyv/Er5Ex5TLWW/wV6eclGSXKI4S3ekzlwjEoBpsTDyb2QNBkfIstmeQYzRP
    m7cHcXKBPi6sZ+H/wb5xQgfoaKmAJqd+p7dbWqb0Sw3y8o6Pra1kJ71N5XuS34rbfUBQ
    XnCw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795732359;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=L8BgtXNBzYX1GjQ1VVae357SREfMavFxSODIa4qd32A=;
    b=Ljc/TmROpM+bJDQo+LaN/dxqoFhxVnByB8o9k/JP8Xg+W4lJSEMS5OBNGcHQCm+yIB
    FoJSkgRU/zxV1/xptQA/7CUeESCereufeo+OGWPZuC4yD6cuYpRmWuiZh6OAEc5nGwAN
    C1n0R31JHWhODvk3Nvl4I2rht7ao1iSvlA1FtjUtXB5BbXkmOlSshnPo1XnLhOHZ7BH9
    HlwJJe0I1b2F6pva0nxGdm9q5jnPdw6K6iWrc5owcxcJ4/Ux8iAZAHm9nDzPn13ROKeb
    S3Bqy1Tl5WhswrwADmIznQfDOOGjE6BbMSiLbLblF0akZmn0GRtuCaKn2NKFd/7Qj+XN
    DetQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795732359;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=L8BgtXNBzYX1GjQ1VVae357SREfMavFxSODIa4qd32A=;
    b=VR416GXqVdQv5kjCqzg2TduE6mwD1RdWtppeAYAdQNGngYsblF0BrjuUOuO0O290EE
    59uOV09EVhJROpw8NfDw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RP16IHIszTD3hB2bKri1qswmSmZySpVjD67C0o="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AQMWcfOj
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 26 Nov 2026 23:32:38 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bean Huo <beanhuo@micron.com>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Avri Altman <avri.altman@sandisk.com>,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 0/2] PM / devfreq: check the get_cur_freq() return value
Date: Thu, 26 Nov 2026 23:32:23 +0100
Message-Id: <20261126223225.2257410-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
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
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

devfreq_set_target() does not check the return value of the optional
->get_cur_freq() callback, so a failing callback can leave an
uninitialized frequency in freqs.old for the transition notifiers.
Patch 1 fixes that by falling back to previous_freq, like the other two
callers already do. Patch 2 writes down what a driver is expected to
return from the callback.

v2 had four patches. Martin applied patches 3 and 4 (the ufshcd part)
to the SCSI tree, so this v3 only has the two devfreq patches.

Changes since v2:
- Patch 1: do not call ->get_cur_freq() inside the if condition. Read
  the frequency into a local variable and only use it when the callback
  returns 0, as Chanwoo suggested. Behavior is the same as in v2. I kept
  the Reviewed-by tags from Avri and Jie, since only the form of the
  code changed; please tell me if that is not OK.
- Patch 1 and 2: add Reviewed-by from Jie Zhan.
- Patch 2: add Acked-by from Chanwoo Choi. No change in the patch.

v2: https://lore.kernel.org/all/20260907192140.2701755-1-beanhuo@iokpp.de/

Bean Huo (2):
  PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
  PM / devfreq: Add more details to the get_cur_freq() comment

 drivers/devfreq/devfreq.c | 12 +++++++-----
 include/linux/devfreq.h   |  7 +++++--
 2 files changed, 12 insertions(+), 7 deletions(-)


base-commit: 4ff20abe28d65a0c52f0b280008fcfb93c3ee2b2
-- 
2.34.1


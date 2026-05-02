Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44EF1EEA31;
	Sat,  2 May 2026 06:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777701631; cv=none; b=ZtVHXCRIuMwTaXoEXl2pxbnX/j/cJzs0M9pWyUhwlR5BpxKNNVDPh43t+Z5mAc+V0Uv/0oGlFLlbVbArahy+i8XN95jLmgUJEutbWN/jO5pP7OJ2TnhOiCh+h7c5D8AEosxKzJ5Xh0mpKJyI+JTl+VOqysjelN+gg2n9FdUAOJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777701631; c=relaxed/simple;
	bh=pXOloY3lphl5mElBnI/9UQERARBIL+Gg4okLCV0K5MA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=OC8s2CiFGldJfMQ1uTuGSj+9jj74ALn4uHxQ0GxScvEQwUiJAVFTQF9Je341pfY53FWxjCdCP1l70hX4pkHVmbDaMGrU/GvVHQmPyZ/T7eqwOSkW/Te+qBfg33v8pbBnan9eFshK9T5HJlS7JpdPpWoatquR734AK+moF2I7Qbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=c8+kRp4j; arc=none smtp.client-ip=203.205.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="c8+kRp4j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777701621; bh=lyJBF7d1vG35Pt9fxGnBS8EczaZilKET3yjPWN0L0Ds=;
	h=From:To:Cc:Subject:Date;
	b=c8+kRp4jeuyDgP0GvjSJcxYpdk34aFYQAYiZW9lfl4vWpLuAnZxmvOK12P0a5AZ13
	 yl7Lmb0mImmH2YAbiQIkjhuNNGI9NsLYZi+Dpu+F0cn7xLq74Y3aQ2sB4YfPctDos3
	 Ps1Y4d1DXBi1o8WCipwCsxS6N7p36WBhrStMZLnA=
Received: from Lang.smartont.net ([2409:8a44:2312:14e1:56d8:1e1e:3f0b:d0f3])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 1296040; Sat, 02 May 2026 14:00:18 +0800
X-QQ-mid: xmsmtpt1777701618t7zxo2mcs
Message-ID: <tencent_7512B915400FB95849FE9A8F8CAA2F935709@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4AgWLw47IzgtYUCt40+ZI2CkQN/9bl+IqXzwGqdHRD0Bv1fQVa3cg
	 Jwlg5jJNVgjVI5Y1TvpFcFmOvfqKmODtS2qePx5udv24/523kXg0NbTCVSGXIbtIMuR0ovdXbkyc
	 2Hg1IWWpdyfwPZrMUvZQlyBRCmNdXXbtcf0kIXup4Bb25cxRMI8I75nWgvQmV2QiY9LOCLLa+WKy
	 DNUM86Q0r0uZlqO4zJ46l51t64E4nWuw5avpWFMzye9XM4jG9Xp40NoWTkXcs3QI4gKqDM+4fvi0
	 8hQvqNyiXuebHjN7mp+kRxd/+D1eNQopLJ0mGsPHk9piv50fjaIpnE0fHKog+JVS8pcEKAgK56vg
	 BFi+pTmBs0N8NiO/abVaTomlJVC8iNOy7sZhtzjdXs9IKGsDP/oYS6V+wDG78Af2J1P+gMxqyeiQ
	 AY53PWnncNz8p8/X9JpCDZluH/Uynz4SWFigACRuvqKC07K+Ho2zKAskimPN6uASWZQP0IyXZV2W
	 cWNwCTcMZGkKra11ZBdH1nC5H/jp/1ggaFC5tM9K04fRFSOzeSysZ2GXk2B3FJs9lFNWJS+MhNec
	 1+wrHHBJe8nUzwZZLSsEcKnRveEU9eEUoOU1j5WD57dAviFBGEzEj3vd/aZgHM0LAlmWMwXoOl++
	 Rr7vR1IehFv31eBByYiZNd2YNOvAB04C61568c4MDMkjSmT3y8Q3zeH1xX1V0Wcr/MWUWN7cf/ec
	 YAUSiA3LDtwaTxH4KtOVdOl5InUbBuifQUbmbZ+7YxnY8ldVxWDiYk+1Dd92d96TQRgggqAA3Zz/
	 m78aDv5hLmU5Wz7K1XdSih4Y+2g++LrrRrC4rf5gLgN7JWFu+OehLxMNlDW7qFOegxJ5bU0UHBE9
	 dTPj086I6iTDt3BddQIe+nRXde1gL22mq6fr4Ob0gcd6qJ/JIYmdOA2ZPpHYnDvwuWLbEPHj4JFc
	 Mhl4zTac4SxwVKep742UAqs5CW0GdMeWPf3FNK4wij/IgCGRQY7sC8J1qgiK1IPdo3PlyO4CIt8m
	 bQ+2PMFvKNNVix6a+Pb0bAWD1MkqQpSnnt+C/puGY6sTG7XbS1QZ1B0R9C1bv45JwJUAGJ8q0DuS
	 lnzc4/
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Wang Zihan <jiyu03@qq.com>
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Wang Zihan <jiyu03@qq.com>
Subject: [PATCH 4/4] scsi: st: fix typo in documentation
Date: Sat,  2 May 2026 13:59:11 +0800
X-OQ-MSGID: <20260502055911.117496-1-jiyu03@qq.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "form" to "from" in drive buffers description.

Signed-off-by: Wang Zihan <jiyu03@qq.com>
---
 Documentation/scsi/st.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scsi/st.rst b/Documentation/scsi/st.rst
index b4a092faa..539ff06da 100644
--- a/Documentation/scsi/st.rst
+++ b/Documentation/scsi/st.rst
@@ -93,7 +93,7 @@ optionally written. In both cases end of data is signified by
 returning zero bytes for two consecutive reads.
 
 Writing filemarks without the immediate bit set in the SCSI command block acts
-as a synchronization point, i.e., all remaining data form the drive buffers is
+as a synchronization point, i.e., all remaining data from the drive buffers is
 written to tape before the command returns. This makes sure that write errors
 are caught at that point, but this takes time. In some applications, several
 consecutive files must be written fast. The MTWEOFI operation can be used to
-- 
2.54.0


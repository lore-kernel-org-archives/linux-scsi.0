Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB54EAE7;
	Sun, 16 Feb 2025 03:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739677246; cv=none; b=QDFX1WShaPBIIn7LAwE31pHHDpDlDJi4mhkgJlsf2YGBeX2tkJU6aeIP++147FKyFv9eERG95lr4RlGyfXHEiUmrvSQVUdjyX19hCsLGA3k3ZyNw9YxtXTwgoZhaJ6PiCzbvy8JN/bHdsBgi6LWWVjNuAhc8a9gTqEzEDieIRxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739677246; c=relaxed/simple;
	bh=Wcty8pe7B2Tf6I5Y3sOaB5gFDgtEePJPAdjZoMgF+XI=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=WmACFGnOLu7nh0oPGsHLo6V+cDzv8B/vHIkCP7iY+hR9twD0xnolNLSrwfvOkCJt1aKv/XLrvGwpveTO7j9e4IvA7TW+CIzLpZvXSbGq8iyBu+pUPuG/eB5hhq9KDEbWAXT2wQelfpgU6wrf1W5WcMmEobGGyjptXzJTzBDekbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=jCdi2ZfH; arc=none smtp.client-ip=203.205.221.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jCdi2ZfH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1739676926; bh=CWzaiTGgr93I8rHQ/1BWEf+YTpf0/vC+SPn40nWrVxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCdi2ZfHLSoNTw3vuVkmpvUL7YsuMj+SJGlpcT+As8/xlZCIM1RLlN/SuYO2iK7F3
	 /OwQ8EIZ3Pvxm8JLU3/8s7KKKB0JBcDvRG6QA3SKubORI5E5O4XrP2GViCS2+dIv18
	 SscDQ52Lwbk66EukTYRELJH79z3aKBAkl3eGW/yI=
Received: from pek-lxu-l1.wrs.com ([114.244.57.157])
	by newxmesmtplogicsvrszgpua8-1.qq.com (NewEsmtp) with SMTP
	id 8D80CA62; Sun, 16 Feb 2025 11:35:24 +0800
X-QQ-mid: xmsmtpt1739676924trpn3ya0b
Message-ID: <tencent_E2504B081B1B2582BA8CBBB133399E6E1B08@qq.com>
X-QQ-XMAILINFO: OZsapEVPoiO6BMQn6N71C0got7T98mlOR8mjSXEiJYdgzBjeJjz/qA8UgHEqhO
	 UjtDJxPSVfC8SG1iY2fm+A4c9xhDeb/A1Hga7V4HoJUwkM8VORTjaAP1UcgY/ziphG3HzHp7br3f
	 cUfJ/hfu2PYlOChr+1AinolBQdVnpANYims4GGpFWS0dVzKuHybESCOEQfo77J5WIzg707LHO26F
	 mIQbt65zpGgFkXphveGOSWSaEwkaGRLaNZtjSsvAQif4PgYPstmM/nt992R21ErLW1M+T+Be9axc
	 lUSi7hrQ3OgK5qjbCHXe8B3jI27RwEK/emEyUNiD8gbV+3vvUMOnW/H2ulujaWnR4aNS9PmxBs90
	 INexXEpQ4HriJ+Q/6+Ck/3l5ygXYfyWCr2sniZzmx8HPKMD7Vo+8KHNasNWh3IMiQZVT1OlqZKFP
	 ECnwh4jbHF5FSuCBcHVOwrJE7cvvNKbASppIODML0ece8/i++DQD7obySgfY2Xf5oyxIeyZqwcn3
	 XxkJkYCN7ofrLqczBXEq2Tr0DtKaeelfcPdKTD91DLlbH5LchxV9iNC/9w5IKkO9duHuhiZt2xD7
	 XwfbVbjf1FQ0iyoPHYHBwgudGRFl5ai4VtC0XNc1GExz8hmaw6GBv8gzm7wfEROInCCtHbQhMBdq
	 JjsoH0/XmvCWlZnw6B8pT1yanJ9b25vL0DzxJGUOQl8KLTX4AaeuXIv99qIMds7PWGnwGuEIfMTS
	 O+QP2a2ESLIFFd86uj5Unf5MLFxOqbYzWImO9AYGMOV2F+X4HOUVM6vl+lfTqZGAGk/ymYyMgQDe
	 ESDQ2aiO5Khjw0djTz03DWPE7DgQOlr3X75DXtdiSrTECG3n6Srzr4JmkELdGeHiVZU9T2EsSjC7
	 4ZlH1c6ulaT0BuzBFH60RpZnLGEPflYrdhRsba5hHz
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Cc: James.Bottomley@HansenPartnership.com,
	dgilbert@interlog.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] scsi: sg: prevent the use of size 0 to obtain the page order of sg
Date: Sun, 16 Feb 2025 11:35:24 +0800
X-OQ-MSGID: <20250216033523.1905699-2-eadavis@qq.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <67afa060.050a0220.21dd3.0052.GAE@google.com>
References: <67afa060.050a0220.21dd3.0052.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a shift-out-of-bounds in sg_build_indirect. [1]

The reproducer changes the value of scatter_elem_sz to 0 before executing
the open operation to open "/dev/sg0", which leads to [1].

When the value of num is 0, set its value to PAGE_SIZE to avoid this oob.

[1]
UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1897:13
shift exponent 64 is too large for 32-bit type 'int'
CPU: 1 UID: 0 PID: 5832 Comm: syz-executor361 Not tainted 6.14.0-rc2-syzkaller-00185-g128c8f96eb86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x24f/0x3f0 lib/ubsan.c:468
 sg_build_indirect.cold+0x1b/0x20 drivers/scsi/sg.c:1897
 sg_build_reserve+0xc4/0x180 drivers/scsi/sg.c:2007
 sg_add_sfp drivers/scsi/sg.c:2189 [inline]
 sg_open+0xc37/0x1910 drivers/scsi/sg.c:348
 chrdev_open+0x237/0x6a0 fs/char_dev.c:414
 do_dentry_open+0x735/0x1c40 fs/open.c:956
 vfs_open+0x82/0x3f0 fs/open.c:1086
 do_open fs/namei.c:3830 [inline]
 path_openat+0x1e88/0x2d80 fs/namei.c:3989
 do_filp_open+0x20c/0x470 fs/namei.c:4016
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_openat fs/open.c:1459 [inline]
 __se_sys_openat fs/open.c:1454 [inline]
 __x64_sys_openat+0x175/0x210 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 drivers/scsi/sg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index effb7e768165..a9c445b7dab3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1888,6 +1888,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		if (num < PAGE_SIZE) {
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
+			if (!num)
+				num = PAGE_SIZE;
 		} else
 			scatter_elem_sz_prev = num;
 	}
-- 
2.43.0


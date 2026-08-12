Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689C12D3ED1;
	Wed, 12 Aug 2026 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786551764; cv=none; b=KYR1mUEWuyAocWpVRmLwR1lnIUtV1HXaInVucjQOqh80Anby3z8FNqOaSURj3rLJYclbXNgefEMU61SBsPtxKWIxeSddO2nUe/guu2wmACCRc2Ef+u19D94X/EaHx0RkdjxCImA5uPWQVDRLswEff4pi3kRRdQ3y01kEyKUFWOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786551764; c=relaxed/simple;
	bh=09P5j5vtzsQVhIo7m5gslnzhGBDHGynNcRhi2xCdQgM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=uQc7dn4VzPK5rx8qojnEWfT/3rs9TeYiseCI+iMhxTvrTfvtXRGbsIDSrxgIupX+HHy/Jk75Xyw+4KDwwlpBfPqLLgrlH5bXEuf2Ediiq4aAgSHYQfAApG2W0QSxBZfwO8r8DaoPsC+pj1cqPgqd6hfcD6nuFDlNKNv8jF0uwWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=u0lMdiKI; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="u0lMdiKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786551731; bh=TZ28Mi0EYyZwR5mH0KkIhD94xAIzMkOmOxSrbGoCFq4=;
	h=Date:To:Cc:From:Subject;
	b=u0lMdiKInK2JCC0zIq8k+tt0IN3US6dqxkPDj9kwD4H9XaRjc8if94PHQRoxlQuMX
	 tiBAOEbBMmYAIWb1sqAij1uus3e+vMIKv4zpXgHmfxu4MNUaNuHzjVJaGnCczYGxIM
	 8rmcRLuxb1y+bAuI5Hx1BiSQR/eR5daJ5fpOdPjM=
Received: from [IPV6:2409:8a00:7894:a160:585d:605d:694d:91cf] ([2409:8a00:7894:a160:585d:605d:694d:91cf])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 589990D9; Thu, 13 Aug 2026 00:22:09 +0800
X-QQ-mid: xmsmtpt1786551729txj9r7zcb
Message-ID: <tencent_FED028EFBFB3FC99E7D4B66C37AF09B1C907@qq.com>
X-QQ-XMAILINFO: MOnz+xTS1+9iZqyqMfh6w+T+tBeJUPJtFQKURpjlnmkx6qMNrwxKe1iufi2z74
	 BtbM8Tn+IHGX6kkOWx9AczgltH9QcL+L02oynCBbpHEQYX2NOJnVb5c+Q7Hfc/Hbzph7QpuEhs+O
	 42kcNCo+whqPHFtifJyYH+r6m4sfNBbGDq5s0YZAIMm18oht6p+TR4Gjn01Cg2N2/xnAIPtY5j3c
	 DrZbDvTXVpThfZj24jTEq5sbpf4wJX074W7I5mtUkg9M8BUYdE2+kMGPblITvNcGVhuIXkSGaOp8
	 d5c+Qzobch8m0ZbtsdBOYg0xQlQHJqCtl/bc3GZ4GebwsGtQCN0/Yt0bOtR032COoehnRFKHcFOF
	 KBg31NVZ59YW8+OCqNvjQANyIDTNWsHn4WM28zhRULd+9+taVgspTkbpP9/D70yIHO+d0ehho1ln
	 /kJTtNKmh9GPlaTR70qyAo/IFfKcCUE2CcmtTcTxmngMGSpPYGGNSykJMniJ/nxtqE9dZNB0Wd6k
	 Gv9GNjDKeBLzDHs70vbnV13Z9o6H79Xlaf4KZF9yfROkZhc6eZ1YV3Ibfxu/pjCXfRpkNHu7hnJN
	 /c55UhjpGhD2HNMR+54/YO6IgrrzKRJvDzp2IAePsvWa69THleQo2534NXO/KXNnEOhIQJ3CRFC2
	 eNvw+HEotdByqEHek4pJY1cydhxrvZc2fb4tVuuv1O0koyFa4KG8Kc+lPMWL/OAbBVfnnZC7CE9Y
	 3rSfduWGGq6wimV2liQGS91opHw7J3WjzfxcRlqU4+A7Sm985NMOT3NB5yb1gHrLXWTa10gKjeXc
	 r9Hkqf7tkhI2aWQgWNgl55e5aS9gdY6i+eCQ9ttF8ah7qre+M20+M+9jg6Pwmj9P3YwRym2AEzeF
	 yhzkkCP/6AK/cbpbxZAnd/OLM1BcQV/1jQqeCsXs9OTBY8EFsCBtvTOs4eVmVdtZLNhQzNM1E9yf
	 vX61VS5fFly02VXlxn0lZkXgIgQppbyGQG2dNhysvn17esQQ9adsPNQNY2pAGrdK7iCKfnqYgeOI
	 TvT93+2NCdyZWriyelfCKmnGF1cJ229ajFGV4c+jpcasBN86o+kUHirnAWvlgUbGyCPi9tvbla7A
	 VCp/JFLw1SYzLdtrc=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <a2032035-2812-4c72-8dab-e48e1594dacc@qq.com>
Date: Thu, 13 Aug 2026 00:22:09 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
From: Yang Zi <2959243019@qq.com>
Subject: =?UTF-8?Q?=5BBUG=5D_KASAN=3A_use-after-free_in_=5F=5Funwind=5Fstart?=
 =?UTF-8?Q?_=28arch/x86/kernel/unwind=5Forc=2Ec=29_=E2=80=94_stack_overflow_?=
 =?UTF-8?Q?on_qedi_probe_failure_=5Bqedi=5D_=5Bsyzkaller=5D?=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

While fuzzing the kernel v7.1 with syzkaller, we hit a use-after-free during 
qedi driver probe that we believe originates in a stack overflow, not a classic 
slab lifetime bug.

Reproducer summary (see attached report/log):

    BUG: KASAN: use-after-free in __unwind_start+0x26/0x310 arch/x86/kernel/unwind_orc.c:715
    Write of size 112 at addr ffff88800ea57f40 by task modprobe/1146

The task was `modprobe (1146)` (Tainted G W O) loading qedi/qed. The crash is
preceded by qed initialization failures:
    [qed_hw_prepare_single:4684] Failed to get HW information
    [qed_probe:513] hw prepare failed
    [__qedi_probe:2563] Cannot initialize hardware
and critically the kernel reported:
    modprobe (1146) used greatest stack depth: 8 bytes left

Root-cause hypothesis: on qedi probe failure, the deep nested error/cleanup
path (qed_hw_prepare_single -> qed_int_igu_read_cam -> qed_hw_get_nvm_info ->
qed_mcp_cmd_init, ...) drives the process stack to within 8 bytes of the
limit. When the WARNING path triggers the ORC unwinder, `__unwind_start`
executes `memset(state, 0, sizeof(*state))` (STRUCT_UNWIND_STATE = 112B).
Writing 112 bytes through an 8-byte stack headroom overflows past the stack
boundary into a freed/unmapped physical page, which KASAN flags as a
use-after-free write (size 112). This is identical to the already-observed
id103 pattern (mode J).

The crash report attached below:

BUG: KASAN: use-after-free in __unwind_start+0x26/0x310 arch/x86/kernel/unwind_orc.c:715
Write of size 112 at addr ffff88800ea57f30 by task modprobe/1146

CPU: 0 UID: 0 PID: 1146 Comm: modprobe Tainted: G        W  O        7.1.0 #1 PREEMPT(lazy) 
Tainted: [W]=WARN, [O]=OOT_MODULE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xea57
flags: 0x100000000000000(node=0|zone=1)
raw: 0100000000000000 0000000000000000 ffffea00003a95c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88800ea57e00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88800ea57e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88800ea57f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff88800ea57f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88800ea58000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
------------[ cut here ]------------
WARNING: kernel/entry/common.c:140 at raw_irqentry_exit_cond_resched+0x46/0x50 kernel/entry/common.c:140, CPU#0: modprobe/1146
Modules linked in: qedi(+) iscsi_boot_sysfs libiscsi scsi_transport_iscsi qed kt_runtime(O) uio_pci_kerneltracker_driver(O)
CPU: 0 UID: 0 PID: 1146 Comm: modprobe Tainted: G        W  O        7.1.0 #1 PREEMPT(lazy) 
Tainted: [W]=WARN, [O]=OOT_MODULE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:raw_irqentry_exit_cond_resched+0x46/0x50 kernel/entry/common.c:140
Code: 36 e6 04 48 29 e0 48 3d 00 80 00 00 73 1b 65 48 8b 05 76 36 e6 04 48 f7 00 10 00 00 00 0f 85 31 4b 19 02 c3 cc cc cc cc cc 90 <0f> 0b 90 eb df 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffff88800ea57ca0 EFLAGS: 00010006
RAX: 0000000000008360 RBX: 0000000000000000 RCX: ffff888009cb51c0
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: ffffffff8501e810
RBP: 0000000000000000 R08: ffff888008a8c053 R09: 1ffff1100115180a
R10: dffffc0000000000 R11: ffffed100115180b R12: 0000000000000000
R13: 0000000000000000 R14: ffff88800ea57d08 R15: 0000000000000000
FS:  00007fee16e6f080(0000) GS:ffff8880e6ae3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005627f0cc5518 CR3: 0000000050c6d000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 </TASK>
irq event stamp: 90422
hardirqs last  enabled at (90421): [<ffffffff8367c433>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:187 [inline]
hardirqs last  enabled at (90421): [<ffffffff8367c433>] _raw_spin_unlock_irq+0x23/0x40 kernel/locking/spinlock.c:206
hardirqs last disabled at (90422): [<ffffffff81380bcd>] handle_softirqs+0x3ed/0x540 kernel/softirq.c:637
softirqs last  enabled at (90212): [<ffffffff81380f0b>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last  enabled at (90212): [<ffffffff81380f0b>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last  enabled at (90212): [<ffffffff81380f0b>] __irq_exit_rcu+0x8b/0x150 kernel/softirq.c:735
softirqs last disabled at (90203): [<ffffffff81380f0b>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last disabled at (90203): [<ffffffff81380f0b>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last disabled at (90203): [<ffffffff81380f0b>] __irq_exit_rcu+0x8b/0x150 kernel/softirq.c:735
---[ end trace 0000000000000000 ]---
[qed_load_mcp_offsets:178()]The address of the MCP scratch-pad is not configured
[qed_mcp_cmd_init:257()]MCP is not initialized
[qed_mcp_cmd_and_union:589()]MFW is not initialized!
[qed_hw_get_nvm_info:4057()]Shared memory not initialized
[qed_int_igu_read_cam:2258()]IGU CAM returned invalid values igu_dsb_id=0xffff
[qed_hw_prepare_single:4682()]Failed to get HW information
[qed_probe:513()]hw prepare failed
[0000:00:05.0]:[__qedi_probe:2563]:6: Cannot initialize hardware
modprobe (1146) used greatest stack depth: 8 bytes left

Regards,
Yang Zi


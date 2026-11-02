Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645279;
	b=zTomc2bGA59WNk4RbF1q/Ps9LG+iEVai84cflvQ44PWQ1OgczHo+vfiqte5Xld0tISLM
	 Q8A0HA16kJAqfD9F/9qor32PVJPEtSjtDXi8En6swvXrQCZrRB1dgs1JX4HgbvxSmTyKR
	 omZP9b7FjVVqSofBjUWa1HrF5muJFADMvYCb7j5F0zb3iskAZY9r1Gr3njSdJ75QO+csd
	 kKPx/Xj1vmWAGn7XBuu/Awt/MmXvFGCkFwHRRaPPRMWc+PtbUbnPZL5HC5P0nTHxmCcHW
	 daatV2uGERjvUn1ae8mEgIOxVidd8JFVf87pr4ulAUioy6u3Sh4U5d6NtZZGkOR9xEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645279;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=NINzsnxlcNCJviNM+jehUVHHu2lA976NL/WR3aLmvns=;
	b=4TVaLHn4bjA3J4ygFMVDg2Ju+bqv6EWatPgWejWE5oNGW+qVC/Eu49heCqSoimkaKH/Q
	 dj4afXHurT3MH44wQWX0uYSCrmn5si+XRwUMGilqme3fZqQzxiKQjhGgEy7cdYIMRS5B2
	 rzPBZA6kxgZrTUQOZ5acCZRsWqhvuyD0Fj8aYWr0NBW38qtjJqvy19M9uXKq7k8n5auO+
	 OS3kAJS43PEM8JuK6mijj7/Eg0e0rHIcbEAIkVjecMIfDmuLdTiSIhQ6OHVhapldflfhU
	 NG/xCnXrgnxWkmvC7o3FXpiMFOf1BdjKAr/8fDjKZs63tzTKtJf6NR6VbGzuaPDOJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=M7PgCsA+;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81FB606A326
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 18:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E81FB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=M7PgCsA+
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1306D1C14;
	Mon,  2 Nov 2026 10:47:55 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCD543F673;
	Mon,  2 Nov 2026 10:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793645278; bh=Jjexl7CAIgvCGdj+uskd93LdYsIeQki1izj1Avh/Cpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7PgCsA+gZltRJ4NvXToqoM4/cTNGkjOFPCGP2fxu3fMALylG2+rtZeUheBN5b8dH
	 W8v8XueWszI6C3GMfawMq8qLNks7M+SHDwHMCDI2XWQDv/8onRJVfJpJxomto/AexD
	 MI0C4qN9CqFomJxIUnFMhS/FnldM81lt/Yy1xFec=
Date: Mon, 2 Nov 2026 18:47:53 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: cki-project@redhat.com
Cc: mpatalan@redhat.com, ftjahjad@redhat.com, fsuba@redhat.com,
	linux-arm-kernel@lists.infradead.org, jmoyer@redhat.com,
	will@kernel.org, bgoncalv@redhat.com,
	Ming Lei <ming.lei@redhat.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: =?utf-8?B?4p2MIEZBSUwgKE1JU1NFRCAxMCBv?=
 =?utf-8?Q?f_54=29=3A_Test_repor?= =?utf-8?Q?t?= for for-kernelci (7.4.0-rc1,
 upstream-arm-next, 6628e7d4)
Message-ID: <auja2VnJTp-ijxqu@arm.com>
References: <13572.126110208530702698@us-mta-627.us.mimecast.lan>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13572.126110208530702698@us-mta-627.us.mimecast.lan>

On Mon, Nov 02, 2026 at 01:53:04PM -0000, cki-project@redhat.com wrote:
> Hi, we tested your kernel and here are the results:
> 
>     Overall result: FAILED
>              Merge: OK
>            Compile: OK
>               Test: FAILED
> 
> 
> Kernel information:
>     Commit message: Linux 7.4-rc1
> 
> You can find all the details about the test run at
>     https://datawarehouse.cki-project.org/kcidb/checkouts/redhat:3017229113
> 
> One or more kernel tests failed:
>     Unrecognized or new issues:
>         Boot test
>              aarch64
>                    Logs: https://datawarehouse.cki-project.org/kcidb/tests/redhat:3017229113_aarch64_kernel_kcidb_tool_1200606255_6
>                    Non-passing ran subtests:
>                        ❌ FAIL Panic: Oops:
>                        ⚡ ERROR Warn: External Watchdog Expired

This one doesn't seem to have a console log.

>         Storage - blktests - throtl
>              aarch64
>                    Logs: https://datawarehouse.cki-project.org/kcidb/tests/redhat:3017229113_aarch64_kernel_kcidb_tool_1200606256_8
>                    Non-passing ran subtests:
>                        ❌ FAIL Panic: Oops:
>                        ⚡ ERROR Warn: External Watchdog Expired

Kernel panic here but not arm64 specific. It looks like a possible
scsi_debug teardown race. IIUC, b402a0dce64a ("scsi: scsi_debug: Fix
create target debugfs failure") fixes the synchronization before target
creation but not on module exit. The bug is probably from f084fe52c640
("scsi: scsi_debug: Add debugfs interface to fail target reset") if I
look at the recent fix.

Adding some linux-scsi people. The panic from the log:

  run blktests throtl/001 at 2026-11-02 12:17:14 
  sd 48:0:0:0: [sdb] Synchronizin 
  sd 48:0:0:0: [sdb] Synchronizing SCSI cache 
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098 
  Mem abort info: 
    ESR = 0x0000000096000004 
    EC = 0x25: DABT (current EL), IL = 32 bits 
    SET = 0, FnV = 0 
    EA = 0, S1PTW = 0 
    FSC = 0x04: level 0 translation fault 
  Data abort info: 
    ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000 
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0 
    GCS = 0, Overlay = 0, DirtyBit = 0 
  user pgtable: 4k pages, 48-bit VAs, pgdp=000008001137a000 
  [0000000000000098] pgd=0000000000000000, p4d=0000000000000000 
  Internal error: Oops: 0000000096000004 [#1]  SMP 
  Modules linked in: null_blk scsi_debug(-) sunrpc rfkill vfat fat cppc_cpufreq acpi_ipmi ipmi_ssif ipmi_devintf ipmi_msghandler igb arm_spe_pmu arm_dmc620_pmu arm_cmn arm_dsu_pmu acpi_tad acpiphp_ampere_altra fuse zram lz4hc_compress xfs ghash_ce onboard_usb_dev gf128mul sbsa_gwdt ast i2c_algo_bit xgene_hwmon i2c_dev [last unloaded: null_blk] 
  CPU: 111 UID: 0 PID: 5282 Comm: kworker/u624:1 Not tainted 7.4.0-rc1 #1 PREEMPT(lazy)  
  Hardware name: GIGABYTE R152-P31-00/MP32-AR1-00, BIOS F31n (SCP: 2.10.20220810) 09/30/2022 
  Workqueue: async async_run_entry_fn 
  pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
  pc : down_write+0x30/0xc0 
  lr : __simple_recursive_removal+0x64/0x200 
  sp : ffff800087713c70 
  x29: ffff800087713c70 x28: 0000000000000098 x27: 0000000000000000 
  x26: 0000000040000200 x25: 0000000000000200 x24: ffffb32d18b6e0f8 
  x23: 0000000000000001 x22: ffff07ffab302c00 x21: 000000262b740085 
  x20: 0000000000000000 x19: ffff07ffab302c00 x18: 000000000000006f 
  x17: 643d4d4554535953 x16: ffffb32d19b31ac0 x15: ffffb32d1bfe2200 
  x14: 0000000000000000 x13: 0000000000000028 x12: 0101010101010101 
  x11: 7f7f7f7f7f7f7f7f x10: fefefefefefefeff x9 : ffffb32d189f35dc 
  x8 : 00000026177d76b0 x7 : ffffb32d1bfde000 x6 : ffffb32d185cf628 
  x5 : 000000000002d078 x4 : 0000000000000064 x3 : ffffff8000000000 
  x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000098 
  Call trace: 
   down_write+0x30/0xc0 (P) 
   __simple_recursive_removal+0x64/0x200 
   simple_recursive_removal+0x1c/0x30 
   debugfs_remove+0x64/0x88 
   sdebug_tartget_cleanup_async+0x24/0x48 [scsi_debug] 
   async_run_entry_fn+0x40/0x198 
   process_one_work+0x1b4/0x4b8 
   worker_thread+0x18c/0x2f0 
   kthread+0x128/0x150 
   ret_from_fork+0x10/0x20 
  Code: b9001041 d503201f d2800001 d2800022 (c8e17c02)  

-- 
Catalin

Received: from cmx-torrgo002.bell.net (mta-tor-002.bell.net [209.71.212.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6484E12AAF8;
	Thu,  4 Apr 2024 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.71.212.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712247826; cv=none; b=Rvkwd/xlU0gYXnCkJ3NAF6O7B6bsJ8hs/jLhTX0iw2Mxk6q3sf/uC6coaBI5HcMfA10JvxoyJ9R9HmajLJATSL9RwxEnA9DNGFAkq8NL4SbA9I62ecv2HXy/gfqBwSEYa7iNp0lRhDc2lYvJRHKpRNYVG5Uigw2BREnDSHpz6v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712247826; c=relaxed/simple;
	bh=SJo3GGxFu5ZDo7DE5ZWWqb7EogKfw9h/83lZ+n47Stc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ID/SBUtf3MH2L4Cip9l/fO0aXDOWU6z3GZrK3ekJ8g9vysWaByBbJkjuNOF1NMKYBwllFfAULiGomlDF04METCs8t+lF6PVksSzn8yXuSYxg8VjN44HOal5OgSyVrMVxFI0Nn3lbl55I4Wmfgp/w6rjGpgMh3+BAbjnXWr/uTLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bell.net; spf=pass smtp.mailfrom=bell.net; dkim=pass (2048-bit key) header.d=bell.net header.i=@bell.net header.b=3DZEESol; arc=none smtp.client-ip=209.71.212.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bell.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bell.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bell.net header.i=@bell.net header.b="3DZEESol"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bell.net; s=selector1; t=1712247822; 
        bh=CN/F/BJ2PCBewTH/5qrekNaOFz7yFimtQMcGBgVP4CU=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=3DZEESolKjuOqvYdK5rzcxUwAFVULYKHZk8MD3tBIngkuM3UOPFbTk3C4ujJqmtjLsW2k+CimNCjycw0xdzNaCkGp2M1HXhlJvADVvuJWO/bGS+8BVugkt61/kIyM9mIWrpgKTBA2EIyjkEQGOcSLISdpxMDlt/7Sn1Kz+22INFPO3X0NUEPq//icZE0lIDuKW1p5+J9FpPm8XSlks+g3bZvlcwNt/eHj22nfEskImG9Ie8cMNPNgO1pGdOxqpvy02wyVH1d8R4BnTdIkgHhWlYAnlAVMTXr01HwyOsRGDtm2POUeecVHAOhB9Cd/EhXdZ2lut7RF9Z7j5ti8/PtLA==
X-RG-SOPHOS: Clean
X-RG-VADE-SC: 0
X-RG-VADE: Clean
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 660BF4CD00348EEA
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvledrudefkedguddttdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceugffnnfdpqfgfvfenuceurghilhhouhhtmecufedtudenucenucfjughrpefkffggfgfvvefhufgtgfesthekredttddvjeenucfhrhhomheplfhohhhnucffrghvihguucetnhhglhhinhcuoegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvtheqnecuggftrfgrthhtvghrnhepteekueduffdtgeejgfeikeekheeflefhfeevffdvieelkeduueehkeffhfejgffgnecukfhppedugedvrdduvdeirddukeekrddvhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrddvrdeglegnpdhinhgvthepudegvddruddviedrudekkedrvdehuddpmhgrihhlfhhrohhmpegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvthdpnhgspghrtghpthhtohepfedprhgtphhtthhopegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvthdprhgtphhtthhopehlihhnuhigqdhprghrihhstgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhstghsihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgvvhfkrfepsghrrghsqdgsrghsvgdqohhtfigrohhntdeltdeifidqghhrtgdqudehqddugedvqdduvdeiqddukeekqddvhedurdgushhlrdgsvghllhdrtggrpdgruhhthhgpuhhsvghrpegurghvvgdrrghn
	ghhlihhnsegsvghllhdrnhgvthdpghgvohfkrfepveet
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from [192.168.2.49] (142.126.188.251) by cmx-torrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 660BF4CD00348EEA; Thu, 4 Apr 2024 12:20:08 -0400
Message-ID: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
Date: Thu, 4 Apr 2024 12:20:08 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-parisc <linux-parisc@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
From: John David Anglin <dave.anglin@bell.net>
Subject: Broken Domain Validation in 6.1.84+
Autocrypt: addr=dave.anglin@bell.net; keydata=
 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
 T70V9SSrl2hiw38vRzsl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I noticed yesterday that Domain Validation is broken in my build of 6.1.84:

dave@mx3210:~$ dmesg
[    0.000000] Linux version 6.1.84+ (dave@mx3210) (hppa64-linux-gnu-gcc (GCC) 12.3.0, GNU ld (GNU Binutils for Debian) 2.42) #1 SMP Wed Apr  3 
23:02:21 UTC 2024
[    0.000000] FP[0] enabled: Rev 1 Model 20
[    0.000000] The 64-bit Kernel has started...
[    0.000000] Kernel default page size is 4 KB. Huge pages enabled with 1 MB physical and 2 MB virtual size.
[    0.000000] Determining PDC firmware type: 64 bit PAT.
[    0.000000] PAT: Running on cell 0 and location 1.
[    0.000000] PAT: legacy revision 0x24, pat_rev 0x201, pdc_cap 0x132, S-PTLB 0, HPMC_RENDEZ 0.
[    0.000000] model 00008870 00000491 00000000 00000002 3e0505e7352af711 100000f0 00000008 000000b2 000000b2
[    0.000000] vers  00000302
[    0.000000] CPUID vers 20 rev 5 (0x00000285)
[    0.000000] capabilities 0x35
[    0.000000] model 9000/800/rp3440
[    0.000000] product A7136A, original product A7136A, S/N: USL24046CJ
[    0.000000] parisc_cache_init: Only equivalent aliasing supported!
[    0.000000] Memory Ranges:
[    0.000000]  0) Start 0x0000000000000000 End 0x000000003fffffff Size   1024 MB
[    0.000000]  1) Start 0x0000000100000000 End 0x00000001ffdfffff Size   4094 MB
[    0.000000]  2) Start 0x0000004040000000 End 0x00000040ffffffff Size   3072 MB
[    0.000000] Total Memory: 8190 MB
[    0.000000] initrd: 7e7c7000-7ffedd5a
[    0.000000] initrd: reserving 3e7c7000-3ffedd5a (mem_max 1ffe00000)
[    0.000000] PDT: type PDT_PAT_NEW, size 3000, entries 2, status 0, dbe_loc 0x201000, good_mem 0 MB
[    0.000000] CRITICAL: Bad memory inside kernel image memory area!
[    0.000000] PDT: Firmware reports 2 entries of faulty memory:
[    0.000000] PDT: BAD MEMORY at 0x00201000, DIMM slot 0a, single-bit error.
[    0.000000] PDT: BAD MEMORY at 0x121edbd80, DIMM slot 0a, permanent multi-bit error.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x00040fffffffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000001ffdfffff]
[    0.000000]   node   0: [mem 0x0000004040000000-0x00000040ffffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000040ffffffff]
[    0.000000] On node 0, zone Normal: 512 pages in unavailable ranges
[    0.000000] percpu: Embedded 35 pages/cpu s105584 r8192 d29584 u143360
[    0.000000] pcpu-alloc: s105584 r8192 d29584 u143360 alloc=35*4096
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15
[    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23
[    0.000000] pcpu-alloc: [0] 24 [0] 25 [0] 26 [0] 27 [0] 28 [0] 29 [0] 30 [0] 31
[    0.000000] SMP: bootstrap CPU ID is 0
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 2063880
[    0.000000] Kernel command line: root=LABEL=ROOT2 console=ttyS0 HOME=/ rootfstype=xfs clocksource=jiffies TERM=xterm palo_kernel=2/vmlinuz 
earlycon=pdc
[    0.000000] earlycon: pdc0 at MMIO32be 0x0000000000000000 (options '')
[    0.000000] printk: bootconsole [pdc0] enabled
[    0.000000] Unknown kernel command line parameters "palo_kernel=2/vmlinuz", will be passed to user space.
[    0.000000] printk: log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] printk: log_buf_len total cpu_extra contributions: 126976 bytes
[    0.000000] printk: log_buf_len min size: 131072 bytes
[    0.000000] printk: log_buf_len: 262144 bytes
[    0.000000] printk: early log buf free: 127760(97%)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.000000] Sorting __ex_table...
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 8179036K/8386560K available (9780K kernel code, 3807K rwdata, 1337K rodata, 1024K init, 632K bss, 207524K reserved, 0K 
cma-reserved)
[    0.000000] SLUB: HWalign=16, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000]  Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] NR_IRQS: 128
[    0.000000] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.000003] sched_clock: 64 bits at 800MHz, resolution 1ns, wraps every 4398046511103ns
[    0.000566] Console: colour dummy device 160x64
[    0.000957] ------------------------
[    0.001043] | Locking API testsuite:
[    0.001129] ----------------------------------------------------------------------------
[    0.006795]                                  | spin |wlock |rlock |mutex | wsem | rsem |rtmutex
[    0.007044] --------------------------------------------------------------------------
[    0.011623]                      A-A deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.016251]                  A-B-B-A deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.021096]              A-B-B-C-C-A deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.021426]              A-B-C-A-B-C deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.025982]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.030644]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.035318]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok |failed|failed|failed|failed|
[    0.035649]                     double unlock:failed|failed|failed|  ok  |failed|failed|  ok  |
[    0.040370]                   initialize held:failed|failed|failed|failed|failed|failed|failed|
[    0.045014] --------------------------------------------------------------------------
[    0.053099]               recursive read-lock:             |  ok |             |failed|
[    0.053363]            recursive read-lock #2:             |  ok |             |failed|
[    0.057926]             mixed read-write-lock: |failed|             |failed|
[    0.062587]             mixed write-read-lock: |failed|             |failed|
[    0.062851]   mixed read-lock/lock-write ABBA: |failed|             |failed|
[    0.062891]    mixed read-lock/lock-read ABBA:             |  ok |             |failed|
[    0.067483]  mixed write-lock/lock-write ABBA: |failed|             |failed|
[    0.072290]   chain cached mixed R-L/L-W ABBA: |failed|
[    0.072534]          rlock W1R2/W2R3/W3R1/123: |failed|
[    0.077248]          rlock W1R2/W2R3/W3R1/132: |failed|
[    0.081822]          rlock W1R2/W2R3/W3R1/213: |failed|
[    0.082017]          rlock W1R2/W2R3/W3R1/231: |failed|
[    0.086757]          rlock W1R2/W2R3/W3R1/312: |failed|
[    0.086951]          rlock W1R2/W2R3/W3R1/321: |failed|
[    0.094817]          rlock W1W2/R2R3/W3R1/123: |failed|
[    0.095009]          rlock W1W2/R2R3/W3R1/132: |failed|
[    0.099559]          rlock W1W2/R2R3/W3R1/213: |failed|
[    0.099752]          rlock W1W2/R2R3/W3R1/231: |failed|
[    0.104610]          rlock W1W2/R2R3/W3R1/312: |failed|
[    0.104802]          rlock W1W2/R2R3/W3R1/321: |failed|
[    0.109341]          rlock W1W2/R2R3/R3W1/123:             |  ok |
[    0.109533]          rlock W1W2/R2R3/R3W1/132:             |  ok |
[    0.114085]          rlock W1W2/R2R3/R3W1/213:             |  ok |
[    0.114278]          rlock W1W2/R2R3/R3W1/231:             |  ok |
[    0.118826]          rlock W1W2/R2R3/R3W1/312:             |  ok |
[    0.119018]          rlock W1W2/R2R3/R3W1/321:             |  ok |
[    0.123691]          rlock W1R2/R2R3/W3W1/123:             |  ok |
[    0.123882]          rlock W1R2/R2R3/W3W1/132:             |  ok |
[    0.128434]          rlock W1R2/R2R3/W3W1/213:             |  ok |
[    0.128626]          rlock W1R2/R2R3/W3W1/231:             |  ok |
[    0.133172]          rlock W1R2/R2R3/W3W1/312:             |  ok |
[    0.141037]          rlock W1R2/R2R3/W3W1/321:             |  ok |
[    0.141227] --------------------------------------------------------------------------
[    0.145841]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok |
[    0.146046]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok |
[    0.150597]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok |
[    0.150802]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok |
[    0.155503]        sirq-safe-A => hirqs-on/12:failed|failed| ok  |
[    0.155710]        sirq-safe-A => hirqs-on/21:failed|failed| ok  |
[    0.160243]          hard-safe-A + irqs-on/12:failed|failed|  ok |
[    0.160449]          soft-safe-A + irqs-on/12:failed|failed|  ok |
[    0.165004]          hard-safe-A + irqs-on/21:failed|failed|  ok |
[    0.165208]          soft-safe-A + irqs-on/21:failed|failed|  ok |
[    0.169937]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok |
[    0.170142]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok |
[    0.174667]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok |
[    0.174872]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok |
[    0.179413]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok |
[    0.179619]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok |
[    0.184163]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok |
[    0.184370]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok |
[    0.192197]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok |
[    0.192402]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok |
[    0.196960]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok |
[    0.197166]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok |
[    0.201710]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok |
[    0.201916]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok |
[    0.206974]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok |
[    0.207179]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok |
[    0.211722]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok |
[    0.211927]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok |
[    0.216479]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok |
[    0.216685]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok |
[    0.221433]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok |
[    0.221639]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok |
[    0.226299]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok |
[    0.226504]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok |
[    0.231062]       hard-irq lock-inversion/123:failed|failed|  ok |
[    0.231269]       soft-irq lock-inversion/123:failed|failed|  ok |
[    0.239175]       hard-irq lock-inversion/132:failed|failed|  ok |
[    0.239382]       soft-irq lock-inversion/132:failed|failed|  ok |
[    0.243926]       hard-irq lock-inversion/213:failed|failed|  ok |
[    0.244139]       soft-irq lock-inversion/213:failed|failed|  ok |
[    0.248666]       hard-irq lock-inversion/231:failed|failed|  ok |
[    0.248872]       soft-irq lock-inversion/231:failed|failed|  ok |
[    0.253580]       hard-irq lock-inversion/312:failed|failed|  ok |
[    0.253787]       soft-irq lock-inversion/312:failed|failed|  ok |
[    0.258310]       hard-irq lock-inversion/321:failed|failed|  ok |
[    0.258516]       soft-irq lock-inversion/321:failed|failed|  ok |
[    0.263061]       hard-irq read-recursion/123:      |failed|  ok |
[    0.263261]       soft-irq read-recursion/123:      |failed|  ok |
[    0.267816]       hard-irq read-recursion/132:      |failed|  ok |
[    0.268024]       soft-irq read-recursion/132:      |failed|  ok |
[    0.272736]       hard-irq read-recursion/213:      |failed|  ok |
[    0.272939]       soft-irq read-recursion/213:      |failed|  ok |
[    0.277489]       hard-irq read-recursion/231:      |failed|  ok |
[    0.277690]       soft-irq read-recursion/231:      |failed|  ok |
[    0.285300]       hard-irq read-recursion/312:      |failed|  ok |
[    0.285500]       soft-irq read-recursion/312:      |failed|  ok |
[    0.290150]       hard-irq read-recursion/321:      |failed|  ok |
[    0.290351]       soft-irq read-recursion/321:      |failed|  ok |
[    0.294898]    hard-irq read-recursion #2/123:      |failed|  ok |
[    0.295100]    soft-irq read-recursion #2/123:      |failed|  ok |
[    0.299654]    hard-irq read-recursion #2/132:      |failed|  ok |
[    0.299856]    soft-irq read-recursion #2/132:      |failed|  ok |
[    0.304551]    hard-irq read-recursion #2/213:      |failed|  ok |
[    0.304751]    soft-irq read-recursion #2/213:      |failed|  ok |
[    0.309287]    hard-irq read-recursion #2/231:      |failed|  ok |
[    0.309487]    soft-irq read-recursion #2/231:      |failed|  ok |
[    0.314029]    hard-irq read-recursion #2/312:      |failed|  ok |
[    0.314229]    soft-irq read-recursion #2/312:      |failed|  ok |
[    0.318787]    hard-irq read-recursion #2/321:      |failed|  ok |
[    0.330374]    soft-irq read-recursion #2/321:      |failed|  ok |
[    0.330573]    hard-irq read-recursion #3/123:      |failed|  ok |
[    0.335109]    soft-irq read-recursion #3/123:      |failed|  ok |
[    0.335313]    hard-irq read-recursion #3/132:      |failed|  ok |
[    0.339971]    soft-irq read-recursion #3/132:      |failed|  ok |
[    0.340180]    hard-irq read-recursion #3/213:      |failed|  ok |
[    0.344714]    soft-irq read-recursion #3/213:      |failed|  ok |
[    0.344918]    hard-irq read-recursion #3/231:      |failed|  ok |
[    0.349439]    soft-irq read-recursion #3/231:      |failed|  ok |
[    0.349642]    hard-irq read-recursion #3/312:      |failed|  ok |
[    0.354336]    soft-irq read-recursion #3/312:      |failed|  ok |
[    0.354539]    hard-irq read-recursion #3/321:      |failed|  ok |
[    0.359067]    soft-irq read-recursion #3/321:      |failed|  ok |
[    0.359271] --------------------------------------------------------------------------
[    0.363892]   | Wound/wait tests |
[    0.363972]   ---------------------
[    0.364062]                   ww api failures:  ok  |  ok  |  ok |
[    0.371936]                ww contexts mixing:failed|  ok  |
[    0.372123]              finishing ww context:  ok  |  ok  |  ok |  ok  |
[    0.376658]                locking mismatches:  ok  |  ok  |  ok |
[    0.376865]                  EDEADLK handling:  ok  |  ok  |  ok |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.381557]            spinlock nest unlocked:failed|
[    0.386447]                spinlock nest test:  ok  |
[    0.386592] -----------------------------------------------------
[    0.386762]                                  |block | try |context|
[    0.391282] -----------------------------------------------------
[    0.391449]                           context:failed|  ok  |  ok |
[    0.396035]                               try:failed|  ok |failed|
[    0.396241]                             block:failed|  ok |failed|
[    0.400784]                          spinlock:failed|  ok |failed|
[    0.400989]   --------------------
[    0.405987]   | fs_reclaim tests |
[    0.406068]   --------------------
[    0.406147]                   correct nesting:  ok  |
[    0.406294]                     wrong nesting:failed|
[    0.413891]                 protected nesting:  ok  |
[    0.414037] --------------------------------------------------------------------------
[    0.418662]   | local_lock tests |
[    0.418744]   ---------------------
[    0.418826]           local_lock inversion  2:  ok  |
[    0.423468]           local_lock inversion 3A:  ok  |
[    0.423615]           local_lock inversion 3B:failed|
[    0.423761]       hardirq_unsafe_softirq_safe:failed|
[    0.428265] --------------------------------------------------------
[    0.428438] 218 out of 355 testcases failed, as expected. |
[    0.433016] ----------------------------------------------------
[    0.433241] Calibrating delay loop... 1594.36 BogoMIPS (lpj=3188736)
[    0.457404] pid_max: default: 32768 minimum: 301
[    0.458065] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.458507] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.465941] cblist_init_generic: Setting adjustable number of callback queues.
[    0.466151] cblist_init_generic: Setting shift to 5 and lim to 1.
[    0.467815] TOC handler registered
[    0.468059] rcu: Hierarchical SRCU implementation.
[    0.468187] rcu:     Max phase no-delay instances is 1000.
[    0.475373] smp: Bringing up secondary CPUs ...
[    0.475494] smp: Brought up 1 node, 1 CPU
[    0.476762] devtmpfs: initialized
[    0.478780] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.479107] futex hash table entries: 8192 (order: 6, 393216 bytes, linear)
[    0.493933] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.497321] audit: initializing netlink subsys (disabled)
[    0.498201] thermal_sys: Registered thermal governor 'step_wise'
[    0.498296] Searching for devices...
[    0.617251] Found devices:
[    0.617314] 1. Storm Peak Slow [128] at 0xfffffffffe780000 { type:0, hv:0x887, sv:0x4, rev:0x0 }
[    0.621252] 2. Storm Peak Slow [129] at 0xfffffffffe781000 { type:0, hv:0x887, sv:0x4, rev:0x0 }
[    0.621740] 3. Storm Peak Slow [152] at 0xfffffffffe798000 { type:0, hv:0x887, sv:0x4, rev:0x0 }
[    0.625247] 4. Storm Peak Slow [153] at 0xfffffffffe799000 { type:0, hv:0x887, sv:0x4, rev:0x0 }
[    0.629246] 5. Everest Mako Memory [8] at 0xfffffffffed08000 { type:1, hv:0xaf, sv:0x9, rev:0x0 }
[    0.629512] 6. Pluto BC McKinley Port [0] at 0xfffffffffed00000 { type:12, hv:0x880, sv:0xc, rev:0x0 }
[    0.637246] 7. Mercury PCI Bridge [0:0] at 0xfffffffffed20000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.641246] 8. Mercury PCI Bridge [0:1] at 0xfffffffffed22000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.645246] 9. Mercury PCI Bridge [0:2] at 0xfffffffffed24000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.649246] 10. Mercury PCI Bridge [0:3] at 0xfffffffffed26000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.649522] 11. Mercury PCI Bridge [0:4] at 0xfffffffffed28000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.653246] 12. Mercury PCI Bridge [0:6] at 0xfffffffffed2c000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.661246] 13. Mercury PCI Bridge [0:7] at 0xfffffffffed2e000 { type:13, hv:0x783, sv:0xa, rev:0x0 }
[    0.665246] 14. BMC IPMI Mgmt Ctlr [16] at 0xfffffff0f05b0000 { type:15, hv:0x4, sv:0xc0, rev:0x0 }
[    0.673255] Enabling PDC_PAT chassis codes support v0.05
[    1.241249] Logical CPU #0 is physical cpu #0 at location 0xffff0000ffff15 with hpa 0xfffffffffe780000
[    1.241655] CPU0: cpu core 0 of socket 0
[    1.249245] Logical CPU #1 is physical cpu #1 at location 0xffff0000ffff15 with hpa 0xfffffffffe781000
[    1.249585] CPU1: cpu core 1 of socket 0
[    1.251068] audit: type=2000 audit(1712197537.496:1): state=initialized audit_enabled=0 res=1
[    1.252385] Releasing cpu 1 now, hpa=fffffffffe781000
[    1.341245] Logical CPU #2 is physical cpu #2 at location 0xffff0001ffff15 with hpa 0xfffffffffe798000
[    1.341578] CPU2: cpu core 0 of socket 1
[    1.342820] Releasing cpu 2 now, hpa=fffffffffe798000
[    1.457245] Logical CPU #3 is physical cpu #3 at location 0xffff0001ffff15 with hpa 0xfffffffffe799000
[    1.457595] CPU3: cpu core 1 of socket 1
[    1.458915] Releasing cpu 3 now, hpa=fffffffffe799000
[    1.541071] CPU(s): 4 out of 4 PA8800 (Mako) at 800.010100 MHz online
[    1.561417] alternatives: applied 53 out of 2460 patches
[    1.591725] Whole cache flush 2696560 cycles, flushing 16777216 bytes 5080984 cycles
[    1.591797] Calculated flush threshold is 8695 KiB
[    1.591949] Cache flush threshold set to 131072 KiB
[    1.594373] Whole TLB flush 30877 cycles, Range flush 16777216 bytes 1798577 cycles
[    1.594620] Calculated TLB flush threshold 1128 KiB
[    1.597282] TLB flush threshold set to 1128 KiB
[    1.633317] SBA found Pluto 2.3 at 0xfffffffffed00000
[    1.945283] Mercury version TR3.2 (0x32) found at 0xfffffffffed20000
[    2.005695] LBA 0:0: PCI host bridge to bus 0000:00
[    2.005891] pci_bus 0000:00: root bus resource [io 0x0000-0xffff]
[    2.006080] pci_bus 0000:00: root bus resource [mem 0xffffffff80000000-0xffffffff8fffffff] (bus address [0x80000000-0x8fffffff])
[    2.006715] pci_bus 0000:00: root bus resource [bus 00-07]
[    2.013339] pci 0000:00:01.0: [1033:0035] type 00 class 0x0c0310
[    2.013574] pci 0000:00:01.0: reg 0x10: [mem 0xffffffff80002000-0xffffffff80002fff]
[    2.017447] pci 0000:00:01.0: supports D1 D2
[    2.017575] pci 0000:00:01.0: PME# supported from D0 D1 D2 D3hot
[    2.021593] pci 0000:00:01.1: [1033:0035] type 00 class 0x0c0310
[    2.021810] pci 0000:00:01.1: reg 0x10: [mem 0xffffffff80001000-0xffffffff80001fff]
[    2.029281] pci 0000:00:01.1: supports D1 D2
[    2.029409] pci 0000:00:01.1: PME# supported from D0 D1 D2 D3hot
[    2.033550] pci 0000:00:01.2: [1033:00e0] type 00 class 0x0c0320
[    2.033771] pci 0000:00:01.2: reg 0x10: [mem 0xffffffff80000000-0xffffffff800000ff]
[    2.037415] pci 0000:00:01.2: supports D1 D2
[    2.037543] pci 0000:00:01.2: PME# supported from D0 D1 D2 D3hot
[    2.041554] pci 0000:00:02.0: [1095:0649] type 00 class 0x01018f
[    2.041774] pci 0000:00:02.0: reg 0x10: [io  0x0d18-0x0d1f]
[    2.041957] pci 0000:00:02.0: reg 0x14: [io  0x0d24-0x0d27]
[    2.045273] pci 0000:00:02.0: reg 0x18: [io  0x0d10-0x0d17]
[    2.045460] pci 0000:00:02.0: reg 0x1c: [io  0x0d20-0x0d23]
[    2.049267] pci 0000:00:02.0: reg 0x20: [io  0x0d00-0x0d0f]
[    2.049533] pci 0000:00:02.0: supports D1 D2
[    2.069284] Mercury version TR3.2 (0x32) found at 0xfffffffffed22000
[    2.133319] LBA 0:1: PCI host bridge to bus 0000:20
[    2.133518] pci_bus 0000:20: root bus resource [io 0x10000-0x1ffff] (bus address [0x0000-0xffff])
[    2.134041] pci_bus 0000:20: root bus resource [mem 0xffffffff90000000-0xffffffff9fffffff] (bus address [0x90000000-0x9fffffff])
[    2.137259] pci_bus 0000:20: root bus resource [bus 20-27]
[    2.137509] pci 0000:20:01.0: [1000:0021] type 00 class 0x010000
[    2.141295] pci 0000:20:01.0: reg 0x10: [io  0x12100-0x121ff]
[    2.141498] pci 0000:20:01.0: reg 0x14: [mem 0xffffffff90015000-0xffffffff900153ff 64bit]
[    2.145271] pci 0000:20:01.0: reg 0x1c: [mem 0xffffffff90012000-0xffffffff90013fff 64bit]
[    2.145635] pci 0000:20:01.0: supports D1 D2
[    2.153503] pci 0000:20:01.1: [1000:0021] type 00 class 0x010000
[    2.153717] pci 0000:20:01.1: reg 0x10: [io  0x12000-0x120ff]
[    2.157275] pci 0000:20:01.1: reg 0x14: [mem 0xffffffff90014000-0xffffffff900143ff 64bit]
[    2.157558] pci 0000:20:01.1: reg 0x1c: [mem 0xffffffff90010000-0xffffffff90011fff 64bit]
[    2.165329] pci 0000:20:01.1: supports D1 D2
[    2.165757] pci 0000:20:02.0: [14e4:1645] type 00 class 0x020000
[    2.169293] pci 0000:20:02.0: reg 0x10: [mem 0xffffffff90000000-0xffffffff9000ffff 64bit]
[    2.173404] pci 0000:20:02.0: PME# supported from D3hot D3cold
[    2.193280] Mercury version TR3.2 (0x32) found at 0xfffffffffed24000
[    2.253714] LBA 0:2: PCI host bridge to bus 0000:40
[    2.253918] pci_bus 0000:40: root bus resource [io 0x20000-0x2ffff] (bus address [0x0000-0xffff])
[    2.255298] pci_bus 0000:40: root bus resource [mem 0xffffffffa0000000-0xffffffffafffffff] (bus address [0xa0000000-0xafffffff])
[    2.261277] pci_bus 0000:40: root bus resource [bus 40-47]
[    2.281279] Mercury version TR3.2 (0x32) found at 0xfffffffffed26000
[    2.341634] LBA 0:3: PCI host bridge to bus 0000:60
[    2.341833] pci_bus 0000:60: root bus resource [io 0x30000-0x3ffff] (bus address [0x0000-0xffff])
[    2.342349] pci_bus 0000:60: root bus resource [mem 0xffffffffb0000000-0xffffffffbfffffff] (bus address [0xb0000000-0xbfffffff])
[    2.345262] pci_bus 0000:60: root bus resource [bus 60-67]
[    2.365280] Mercury version TR3.2 (0x32) found at 0xfffffffffed28000
[    2.397262] LBA: lmmio_space [0xffffffffc0000000-0xffffffffdfffffff] - new
[    2.425682] LBA 0:4: PCI host bridge to bus 0000:80
[    2.425884] pci_bus 0000:80: root bus resource [io 0x40000-0x4ffff] (bus address [0x0000-0xffff])
[    2.429256] pci_bus 0000:80: root bus resource [mem 0xffffffffc0000000-0xffffffffdfffffff] (bus address [0xc0000000-0xdfffffff])
[    2.433256] pci_bus 0000:80: root bus resource [bus 80-87]
[    2.453283] Mercury version TR3.2 (0x32) found at 0xfffffffffed2c000
[    2.513681] LBA 0:6: PCI host bridge to bus 0000:c0
[    2.513878] pci_bus 0000:c0: root bus resource [io 0x50000-0x5ffff] (bus address [0x0000-0xffff])
[    2.514437] pci_bus 0000:c0: root bus resource [mem 0xffffffffe0000000-0xffffffffefffffff] (bus address [0xe0000000-0xefffffff])
[    2.517261] pci_bus 0000:c0: root bus resource [bus c0-c7]
[    2.537283] Mercury version TR3.2 (0x32) found at 0xfffffffffed2e000
[    2.569265] LBA: lmmio_space [0xfffffffff0000000-0xfffffffffe77ffff] - new
[    2.601442] LBA 0:7: PCI host bridge to bus 0000:e0
[    2.601641] pci_bus 0000:e0: root bus resource [io 0x60000-0x6ffff] (bus address [0x0000-0xffff])
[    2.602128] pci_bus 0000:e0: root bus resource [mem 0xfffffffff0000000-0xfffffffffe77ffff] (bus address [0xf0000000-0xfe77ffff])
[    2.609258] pci_bus 0000:e0: root bus resource [bus e0-e7]
[    2.609511] pci 0000:e0:01.0: [103c:1290] type 00 class 0x078000
[    2.613343] pci 0000:e0:01.0: reg 0x18: [mem 0xfffffffff4051000-0xfffffffff405100f]
[    2.613702] pci 0000:e0:01.0: Hiding Diva built-in AUX serial device
[    2.617658] pci 0000:e0:01.1: [103c:1048] type 00 class 0x070002
[    2.617883] pci 0000:e0:01.1: reg 0x10: [mem 0xfffffffff4050000-0xfffffffff4050fff]
[    2.621298] pci 0000:e0:01.1: reg 0x18: [mem 0xfffffffff4020000-0xfffffffff403ffff pref]
[    2.629262] pci 0000:e0:02.0: [1002:5159] type 00 class 0x030000
[    2.629485] pci 0000:e0:02.0: reg 0x10: [mem 0xfffffffff0000000-0xfffffffff3ffffff pref]
[    2.633274] pci 0000:e0:02.0: reg 0x14: [io  0x6e000-0x6e0ff]
[    2.633467] pci 0000:e0:02.0: reg 0x18: [mem 0xfffffffff4040000-0xfffffffff404ffff]
[    2.637363] pci 0000:e0:02.0: reg 0x30: [mem 0xfffffffff4000000-0xfffffffff401ffff pref]
[    2.641273] pci 0000:e0:02.0: Hiding Diva built-in ATI card
[    2.641495] pci 0000:e0:02.0: supports D1 D2
[    2.645250] powersw: Soft power switch support not available.
[    2.657423] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    2.657614] HugeTLB: 0 KiB vmemmap can be freed for a 2.00 MiB page
[    2.660033] register_cpu_capacity_sysctl: too early to get CPU4 device!
[    2.660218] register_cpu_capacity_sysctl: too early to get CPU5 device!
[    2.661263] register_cpu_capacity_sysctl: too early to get CPU6 device!
[    2.661448] register_cpu_capacity_sysctl: too early to get CPU7 device!
[    2.665292] register_cpu_capacity_sysctl: too early to get CPU8 device!
[    2.665479] register_cpu_capacity_sysctl: too early to get CPU9 device!
[    2.669248] register_cpu_capacity_sysctl: too early to get CPU10 device!
[    2.673245] register_cpu_capacity_sysctl: too early to get CPU11 device!
[    2.677246] register_cpu_capacity_sysctl: too early to get CPU12 device!
[    2.677433] register_cpu_capacity_sysctl: too early to get CPU13 device!
[    2.681245] register_cpu_capacity_sysctl: too early to get CPU14 device!
[    2.685245] register_cpu_capacity_sysctl: too early to get CPU15 device!
[    2.685431] register_cpu_capacity_sysctl: too early to get CPU16 device!
[    2.693245] register_cpu_capacity_sysctl: too early to get CPU17 device!
[    2.693431] register_cpu_capacity_sysctl: too early to get CPU18 device!
[    2.697245] register_cpu_capacity_sysctl: too early to get CPU19 device!
[    2.697432] register_cpu_capacity_sysctl: too early to get CPU20 device!
[    2.701245] register_cpu_capacity_sysctl: too early to get CPU21 device!
[    2.701432] register_cpu_capacity_sysctl: too early to get CPU22 device!
[    2.709245] register_cpu_capacity_sysctl: too early to get CPU23 device!
[    2.709430] register_cpu_capacity_sysctl: too early to get CPU24 device!
[    2.713245] register_cpu_capacity_sysctl: too early to get CPU25 device!
[    2.717245] register_cpu_capacity_sysctl: too early to get CPU26 device!
[    2.717429] register_cpu_capacity_sysctl: too early to get CPU27 device!
[    2.721246] register_cpu_capacity_sysctl: too early to get CPU28 device!
[    2.721431] register_cpu_capacity_sysctl: too early to get CPU29 device!
[    2.725245] register_cpu_capacity_sysctl: too early to get CPU30 device!
[    2.729245] register_cpu_capacity_sysctl: too early to get CPU31 device!
[    2.733506] pps_core: LinuxPPS API ver. 1 registered
[    2.733643] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.737295] PTP clock support registered
[    2.738475] pci 0000:e0:02.0: vgaarb: setting as boot VGA device
[    2.741235] pci 0000:e0:02.0: vgaarb: bridge control possible
[    2.741235] pci 0000:e0:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    2.749265] vgaarb: loaded
[    2.763504] NET: Registered PF_INET protocol family
[    2.764990] IP idents hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    2.778255] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 98304 bytes, linear)
[    2.778668] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    2.779155] TCP established hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    2.782335] TCP bind hash table entries: 65536 (order: 9, 3145728 bytes, linear)
[    2.788574] TCP: Hash tables configured (established 65536 bind 65536)
[    2.789675] UDP hash table entries: 4096 (order: 6, 262144 bytes, linear)
[    2.790272] UDP-Lite hash table entries: 4096 (order: 6, 262144 bytes, linear)
[    2.797291] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    2.798050] RPC: Registered named UNIX socket transport module.
[    2.801050] RPC: Registered udp transport module.
[    2.801172] RPC: Registered tcp transport module.
[    2.801261] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.805255] PCI: CLS 16 bytes
[    2.845398] pci 0000:00:01.0: quirk_usb_early_handoff+0x0/0x210 took 39062 usecs
[    2.881452] pci 0000:00:01.1: quirk_usb_early_handoff+0x0/0x210 took 35156 usecs
[    2.921441] pci 0000:00:01.2: quirk_usb_early_handoff+0x0/0x210 took 35156 usecs
[    2.921857] clocksource: cr16_unstable: mask: 0xffffffffffffffff max_cycles: 0xb881c00724, max_idle_ns: 440795204253 ns
[    2.922331] Trying to unpack rootfs image as initramfs...
[    2.925277] Performance monitoring counters enabled for Storm Peak Slow [128]
[    2.965924] Initialise system trusted keyrings
[    2.985703] workingset: timestamp_bits=46 max_order=21 bucket_order=0
[    3.087649] Key type asymmetric registered
[    3.087783] Asymmetric key parser 'x509' registered
[    5.367092] Freeing initrd memory: 24728K
[    5.369481] process '/usr/bin/kmod' started with executable stack
[    5.402762] alg: self-tests for CTR-KDF (hmac(sha256)) passed
[    5.403242] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    5.404082] io scheduler mq-deadline registered
[    5.404207] io scheduler kyber registered
[    5.404988] atomic64_test: passed
[    5.511294] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.539089] printk: console [ttyS0] disabled
[    5.539285] 0000:e0:01.1: ttyS0 at MMIO 0xfffffffff4050000 (irq = 73, base_baud = 115200) is a 16550A
[    5.539887] printk: console [ttyS0] enabled
[    5.541431] printk: bootconsole [pdc0] disabled
[    5.549776] 0000:e0:01.1: ttyS1 at MMIO 0xfffffffff4050010 (irq = 73, base_baud = 115200) is a 16550A
[    5.550718] 0000:e0:01.1: ttyS2 at MMIO 0xfffffffff4050038 (irq = 73, base_baud = 115200) is a 16550A
[    5.553831] Linux agpgart interface v0.103
[    6.289580] brd: module loaded
[    6.290128] HP SDC: No SDC found.
[    6.290222] HP SDC MLC: Registering the System Domain Controller's HIL MLC.
[    6.290650] HP SDC MLC: Request for raw HIL ISR hook denied
[    6.293931] mousedev: PS/2 mouse device common for all mice
[    6.301533] rtc-generic rtc-generic: registered as rtc0
[    6.305300] rtc-generic rtc-generic: setting system clock to 2024-04-04T02:25:43 UTC (1712197543)
[    6.309466] IR JVC protocol handler initialized
[    6.309871] IR MCE Keyboard/mouse protocol handler initialized
[    6.310050] IR NEC protocol handler initialized
[    6.310176] IR RC5(x/sz) protocol handler initialized
[    6.313250] IR RC6 protocol handler initialized
[    6.313375] IR SANYO protocol handler initialized
[    6.313510] IR Sharp protocol handler initialized
[    6.317246] IR Sony protocol handler initialized
[    6.317375] IR XMP protocol handler initialized
[    6.317623] hid: raw HID events driver (C) Jiri Kosina
[    6.326987] Loading compiled-in X.509 certificates
[    6.353635] Freeing unused kernel image (initmem) memory: 1024K
[    6.437279] Write protected read-only-after-init data: 41k
[    6.437363] Run /init as init process
[    6.437398]   with arguments:
[    6.437405]     /init
[    6.437413]   with environment:
[    6.437420]     HOME=/
[    6.437427]     TERM=xterm
[    6.437435]     palo_kernel=2/vmlinuz
[    8.006170] scsi_mod alternatives: applied 0 out of 7 patches
[    8.105667] SCSI subsystem initialized
[    8.713738] sym53c8xx alternatives: applied 0 out of 30 patches
[    8.776335] libata alternatives: applied 0 out of 3 patches
[    8.783677] tg3 alternatives: applied 0 out of 89 patches
[    8.846589] libata version 3.00 loaded.
[    8.909871] usbcore alternatives: applied 0 out of 19 patches
[    8.930474] pata_cmd64x 0000:00:02.0: Secondary port is disabled
[    9.029867] usbcore: registered new interface driver usbfs
[    9.030037] usbcore: registered new interface driver hub
[    9.030251] usbcore: registered new device driver usb
[    9.185882] scsi host0: pata_cmd64x
[    9.206870] ehci_hcd alternatives: applied 0 out of 114 patches
[    9.285734] ehci_pci alternatives: applied 0 out of 2 patches
[    9.325358] ehci-pci 0000:00:01.2: EHCI Host Controller
[    9.325528] ehci-pci 0000:00:01.2: new USB bus registered, assigned bus number 1
[    9.326032] ehci-pci 0000:00:01.2: irq 68, io mem 0xffffffff80000000
[    9.327185] scsi host1: pata_cmd64x
[    9.327578] ata1: PATA max UDMA/100 cmd 0xd18 ctl 0xd24 bmdma 0xd00 irq 69
[    9.329265] ata2: DUMMY
[    9.353398] ehci-pci 0000:00:01.2: USB 2.0 started, EHCI 0.95
[    9.393508] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.01
[    9.393625] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.393936] usb usb1: Product: EHCI Host Controller
[    9.393995] usb usb1: Manufacturer: Linux 6.1.84+ ehci_hcd
[    9.394060] usb usb1: SerialNumber: 0000:00:01.2
[    9.393929] ohci_hcd alternatives: applied 0 out of 144 patches
[    9.473138] hub 1-0:1.0: USB hub found
[    9.473287] hub 1-0:1.0: 5 ports detected
[    9.485262] sym0: <1010-66> rev 0x1 at pci 0000:20:01.0 irq 70
[    9.529893] ata1.00: ATAPI: DW-224E, C.0B, max UDMA/33
[    9.553292] sym0: PA-RISC Firmware, ID 7, Fast-80, LVD, parity checking
[    9.637235] sym0: SCSI BUS has been reset.
[    9.637235] scsi host2: sym-2.2.3
[    9.673362] ohci-pci 0000:00:01.0: OHCI PCI host controller
[    9.673539] ohci-pci 0000:00:01.0: new USB bus registered, assigned bus number 2
[    9.674045] ohci-pci 0000:00:01.0: irq 66, io mem 0xffffffff80002000
[    9.675392] scsi 0:0:0:0: CD-ROM            TEAC DW-224E          C.0B PQ: 0 ANSI: 5
[    9.974420] usb 1-3: new high-speed USB device number 2 using ehci-pci
[   10.130884] usb 1-3: New USB device found, idVendor=1058, idProduct=0748, bcdDevice=10.22
[   10.130976] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[   10.131287] usb 1-3: Product: My Passport 0748
[   10.131339] usb 1-3: Manufacturer: Western Digital
[   10.131397] usb 1-3: SerialNumber: 575836314542325A33383231
[   10.269366] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.01
[   10.269366] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.269366] usb usb2: Product: OHCI PCI host controller
[   10.269366] usb usb2: Manufacturer: Linux 6.1.84+ ohci_hcd
[   10.277290] usb usb2: SerialNumber: 0000:00:01.0
[   10.278223] hub 2-0:1.0: USB hub found
[   10.278323] hub 2-0:1.0: 3 ports detected
[   10.297353] ohci-pci 0000:00:01.1: OHCI PCI host controller
[   10.297522] ohci-pci 0000:00:01.1: new USB bus registered, assigned bus number 3
[   10.298013] ohci-pci 0000:00:01.1: irq 67, io mem 0xffffffff80001000
[   10.618625] usb_storage alternatives: applied 0 out of 1 patches
[   10.637622] usb-storage 1-3:1.0: USB Mass Storage device detected
[   10.642069] tg3 0000:20:02.0 eth0: Tigon3 [partno(BCM95700A6) rev 0105] (PCI:66MHz:64-bit) MAC address 00:30:6e:4b:16:4d
[   10.642428] tg3 0000:20:02.0 eth0: attached PHY is 5701 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   10.643829] scsi host3: usb-storage 1-3:1.0
[   10.645267] tg3 0000:20:02.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[0]
[   10.645946] usbcore: registered new interface driver usb-storage
[   10.649252] tg3 0000:20:02.0 eth0: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
[   10.730918] usbcore: registered new interface driver uas
[   11.213541] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 6.01
[   11.213662] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.213977] usb usb3: Product: OHCI PCI host controller
[   11.214036] usb usb3: Manufacturer: Linux 6.1.84+ ohci_hcd
[   11.217254] usb usb3: SerialNumber: 0000:00:01.1
[   11.222054] hub 3-0:1.0: USB hub found
[   11.222054] hub 3-0:1.0: 2 ports detected
[   11.409255] sr 0:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   11.409255] cdrom: Uniform CD-ROM driver Revision: 3.20
[   11.441362] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   11.653074] scsi 3:0:0:0: Direct-Access     WD       My Passport 0748 1022 PQ: 0 ANSI: 6
[   11.733846] scsi 3:0:0:1: Enclosure         WD       SES Device       1022 PQ: 0 ANSI: 6
[   12.832628] scsi 2:0:0:0: Direct-Access     SEAGATE ST3300007LC      D705 PQ: 0 ANSI: 3
[   12.832758] scsi target2:0:0: tagged command queuing enabled, command queue depth 16.
[   12.845277] scsi target2:0:0: Beginning Domain Validation
[   12.845441] ------------[ cut here ]------------
[   12.845485] WARNING: CPU: 2 PID: 711 at drivers/scsi/scsi_lib.c:214 scsi_execute_cmd+0x74/0x258 [scsi_mod]
[   12.845898] Modules linked in: sd_mod t10_pi ses(+) enclosure scsi_transport_sas crc64_rocksoft crc64 uas usb_storage sr_mod cdrom ohci_pci 
ohci_hcd ehci_pci ehci_hcd pata_cmd64x sym53c8xx(+) libata scsi_transport_spi tg3 usbcore scsi_mod scsi_common usb_common
[   12.857265] CPU: 2 PID: 711 Comm: (udev-worker) Not tainted 6.1.84+ #1
[   12.861246] Hardware name: 9000/800/rp3440

[   12.861311]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[   12.861365] PSW: 00001000000001101111111100001111 Not tainted
[   12.865248] r00-03  000000ff0806ff0f 000000004c7a96f0 00000000040a8408 000000004c7a9880
[   12.865341] r04-07  00000000040a6000 000000004c7a9780 000000004c7a9758 000000004bcd3000
[   12.869245] r08-11  000000004bcf2000 0000000000000090 0000000000000070 00000000000009c4
[   12.869338] r12-15  0000000000000001 000000004c7a9608 0000000000000001 0000000000000004
[   12.877245] r16-19  000000004c7a9758 000000004c7a96f8 0000000000000090 000000004c7a9758
[   12.881245] r20-23  0000000000000001 00000000000009c4 0000000000000090 000000004bcf2000
[   12.881340] r24-27  0000000000000722 0000000000000722 000000004bcd3000 0000000018301000
[   12.885245] r28-31  0000000000000060 000000004c7a9850 000000004c7a9950 0000000000000000
[   12.889245] sr00-03  00000000000a1800 0000000000000000 0000000000000000 00000000000a3800
[   12.889339] sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

[   12.901261] IASQ: 0000000000000000 0000000000000000 IAOQ: 000000001831a4d4 000000001831a4d8
[   12.905245]  IIR: 03ffe01f    ISR: 0000000010340000  IOR: 00000031ea7a98d0
[   12.905323]  CPU:        2   CR30: 000000004bc75900 CR31: ffffffffffffffff
[   12.909245]  ORIG_R28: 0000000040c2e1e0
[   12.909287]  IAOQ[0]: scsi_execute_cmd+0x74/0x258 [scsi_mod]
[   12.909387]  IAOQ[1]: scsi_execute_cmd+0x78/0x258 [scsi_mod]
[   12.913249]  RP(r2): spi_execute+0xe8/0x168 [scsi_transport_spi]
[   12.913342] Backtrace:
[   12.913378]  [<00000000040a8408>] spi_execute+0xe8/0x168 [scsi_transport_spi]
[   12.921251]  [<00000000040a8900>] spi_dv_device_compare_inquiry+0xd0/0x190 [scsi_transport_spi]
[   12.921378]  [<00000000040a8aac>] spi_dv_device_internal+0xec/0x698 [scsi_transport_spi]
[   12.925254]  [<00000000040aa194>] spi_dv_device+0x11c/0x1e0 [scsi_transport_spi]
[   12.929255]  [<000000001c600eb4>] sym53c8xx_slave_configure+0x15c/0x170 [sym53c8xx]
[   12.929404]  [<000000001831f97c>] scsi_add_lun+0x3d4/0x678 [scsi_mod]
[   12.933251]  [<0000000018321058>] scsi_probe_and_add_lun+0x170/0x558 [scsi_mod]
[   12.933366]  [<0000000018322058>] __scsi_scan_target+0x150/0x2f0 [scsi_mod]
[   12.941250]  [<0000000018322514>] scsi_scan_host_selected+0x1b4/0x2d0 [scsi_mod]
[   12.941366]  [<0000000018322728>] do_scsi_scan_host+0xf8/0x100 [scsi_mod]
[   12.949252]  [<00000000183229ac>] scsi_scan_host+0x27c/0x298 [scsi_mod]
[   12.949361]  [<000000001c602794>] sym2_probe+0x31c/0x538 [sym53c8xx]
[   12.953250]  [<00000000407ab804>] pci_device_probe+0x144/0x2a8
[   12.953250]  [<000000004085d194>] really_probe+0x12c/0x5b8
[   12.957249]  [<000000004085d6a4>] __driver_probe_device+0x84/0x1a0
[   12.957325]  [<000000004085d878>] driver_probe_device+0xb8/0x270
[   12.957402]  [<000000004085e7f4>] __driver_attach+0x114/0x318
[   12.961249]  [<0000000040858af0>] bus_for_each_dev+0xd0/0x138
[   12.961321]  [<000000004085c5c0>] driver_attach+0x48/0x60
[   12.969266]  [<000000004085b8b4>] bus_add_driver+0x334/0x470
[   12.969343]  [<000000004085fcd4>] driver_register+0xf4/0x2a0
[   12.973249]  [<00000000407aa8a0>] __pci_register_driver+0x88/0xa0
[   12.973311]  [<000000000004b1d4>] sym2_init+0x174/0xfa0 [sym53c8xx]
[   12.977250]  [<00000000402053e4>] do_one_initcall+0x7c/0x320
[   12.977333]  [<00000000402fe6c4>] do_init_module+0x94/0x4b0
[   12.977410]  [<000000004030089c>] load_module+0x137c/0x1528
[   12.981250]  [<0000000040300e60>] __do_sys_finit_module+0x120/0x180
[   12.981331]  [<0000000040300f7c>] sys_finit_module+0x2c/0x40
[   12.989249]  [<0000000040203fbc>] syscall_exit+0x0/0x10

[   12.989337] ---[ end trace 0000000000000000 ]---
[   12.989396] scsi target2:0:0: Domain Validation Initial Inquiry Failed
[   12.997250] scsi target2:0:0: Ending Domain Validation
[   12.998021] sd 2:0:0:0: Power-on or device reset occurred
[   13.002135] sd 2:0:0:0: [sdb] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   13.002271] sd 2:0:0:0: [sdb] Write Protect is off
[   13.005031] sd 2:0:0:0: [sdb] Mode Sense: ab 00 10 08
[   13.006998] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   13.046025]  sdb: sdb1
[   13.069652] sd 2:0:0:0: [sdb] Attached SCSI disk
[   15.465644] scsi 3:0:0:1: Wrong diagnostic page; asked for 1 got 8
[   15.465644] scsi 3:0:0:1: Failed to get diagnostic page 0x1
[   15.465644] scsi 3:0:0:1: Failed to bind enclosure -19
[   15.481638] sd 3:0:0:0: [sda] 3906963456 512-byte logical blocks: (2.00 TB/1.82 TiB)
[   15.482887] sd 3:0:0:0: [sda] Write Protect is off
[   15.482887] sd 3:0:0:0: [sda] Mode Sense: 47 00 10 08
[   15.484262] sd 3:0:0:0: [sda] No Caching mode page found
[   15.484262] sd 3:0:0:0: [sda] Assuming drive cache: write through
[   15.487885] scsi 2:0:1:0: Direct-Access     SEAGATE ST318203LC       HP04 PQ: 0 ANSI: 2
[   15.488008] scsi target2:0:1: tagged command queuing enabled, command queue depth 16.
[   15.510450]  sda: sda1 sda2
[   15.529700] sd 3:0:0:0: [sda] Attached SCSI disk
[   15.530042] ses 3:0:0:1: Attached Enclosure device
[   15.557397] scsi target2:0:1: Beginning Domain Validation
[   15.557635] scsi target2:0:1: Domain Validation Initial Inquiry Failed
[   15.557701] scsi target2:0:1: Ending Domain Validation
[   15.563735] sd 2:0:1:0: Power-on or device reset occurred
[   15.566018] sd 2:0:1:0: [sdc] 35566480 512-byte logical blocks: (18.2 GB/17.0 GiB)
[   15.570971] sd 2:0:1:0: [sdc] Write Protect is off
[   15.571039] sd 2:0:1:0: [sdc] Mode Sense: 9f 00 10 08
[   15.572693] sd 2:0:1:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   15.645753] sd 2:0:1:0: [sdc] Attached SCSI disk
[   15.661389] random: crng init done
[   19.677249] sym1: <1010-66> rev 0x1 at pci 0000:20:01.1 irq 71
[   19.680121] sym1: PA-RISC Firmware, ID 7, Fast-80, LVD, parity checking
[   19.717235] sym1: SCSI BUS has been reset.
[   19.721269] scsi host4: sym-2.2.3
[   23.375758] scsi 4:0:2:0: Direct-Access     SEAGATE ST3300007LC      0005 PQ: 0 ANSI: 3
[   23.375853] scsi target4:0:2: tagged command queuing enabled, command queue depth 16.
[   23.389269] scsi target4:0:2: Beginning Domain Validation
[   23.389434] scsi target4:0:2: Domain Validation Initial Inquiry Failed
[   23.389494] scsi target4:0:2: Ending Domain Validation
[   23.390363] sd 4:0:2:0: Power-on or device reset occurred
[   23.661236] sd 4:0:2:0: [sdd] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   23.681536] sd 4:0:2:0: [sdd] Write Protect is off
[   23.681623] sd 4:0:2:0: [sdd] Mode Sense: ab 00 10 08
[   23.956350] sd 4:0:2:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   25.503234]  sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 sdd7 >
[   25.525853] sd 4:0:2:0: [sdd] Attached SCSI disk
[   30.035175] md_mod alternatives: applied 0 out of 6 patches
[   30.482936] raid1 alternatives: applied 0 out of 2 patches
[   30.881685] raid6: int64x8  gen()   703 MB/s
[   30.949672] raid6: int64x4  gen()   905 MB/s
[   31.017674] raid6: int64x2  gen()   977 MB/s
[   31.085666] raid6: int64x1  gen()   832 MB/s
[   31.085711] raid6: using algorithm int64x2 gen() 977 MB/s
[   31.153652] raid6: .... xor() 445 MB/s, rmw enabled
[   31.153698] raid6: using intx1 recovery algorithm
[   31.213597] xor alternatives: applied 0 out of 2 patches
[   31.253376] xor: measuring software checksum speed
[   31.255158]    8regs           : -1018167296 MB/sec
[   31.259253]    8regs_prefetch  : -1018167296 MB/sec
[   31.262909]    32regs          : -1018167296 MB/sec
[   31.266981]    32regs_prefetch : -1018167296 MB/sec
[   31.267040] xor: using function: 32regs_prefetch (-1018167296 MB/sec)
[   31.740258] raid456 alternatives: applied 0 out of 20 patches
[   32.026148] raid10 alternatives: applied 0 out of 36 patches
[   33.418840] xfs alternatives: applied 0 out of 27 patches
[   33.445650] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[   33.461064] XFS (sdd5): Deprecated V4 format (crc=0) will not be supported after September 2030.
[   33.465815] XFS (sdd5): Mounting V4 Filesystem
[   34.498563] XFS (sdd5): Ending clean mount
[   39.421949] systemd[1]: Inserted module 'autofs4'
[   39.720250] ipv6 alternatives: applied 0 out of 156 patches
[   39.742393] NET: Registered PF_INET6 protocol family
[   39.746893] Segment Routing with IPv6
[   39.746893] In-situ OAM (IOAM) with IPv6
[   39.834744] x_tables alternatives: applied 0 out of 4 patches
[   39.966410] ip_tables alternatives: applied 0 out of 6 patches
[   40.372132] systemd[1]: systemd 255.4-1 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK -SECCOMP +GCRYPT -GNUTLS +OPENSSL 
+ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ 
+ZLIB +ZSTD -BPF_FRAMEWORK -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
[   40.381344] systemd[1]: Detected architecture parisc64.
[   40.442443] systemd[1]: Hostname set to <mx3210>.
[   41.409304] systemd-fstab-generator[836]: Checking was requested for "tmpfs", but it is not a device.
[   49.826157] systemd[1]: Queued start job for default target graphical.target.
[   49.997281] systemd[1]: Created slice system-getty.slice - Slice /system/getty.
[   50.002591] systemd[1]: Created slice system-modprobe.slice - Slice /system/modprobe.
[   50.010006] systemd[1]: Created slice system-postfix.slice - Slice /system/postfix.
[   50.014999] systemd[1]: Created slice system-serial\x2dgetty.slice - Slice /system/serial-getty.
[   50.020079] systemd[1]: Created slice system-systemd\x2dfsck.slice - Slice /system/systemd-fsck.
[   50.023762] systemd[1]: Created slice user.slice - User and Session Slice.
[   50.026127] systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
[   50.031246] systemd[1]: Set up automount proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats File System Automount Point.
[   50.041484] systemd[1]: Expecting device dev-disk-by\x2dlabel-BOOT2.device - /dev/disk/by-label/BOOT2...
[   50.049301] systemd[1]: Expecting device dev-disk-by\x2dlabel-DAVE.device - /dev/disk/by-label/DAVE...
[   50.053662] systemd[1]: Expecting device dev-disk-by\x2dlabel-HOME2.device - /dev/disk/by-label/HOME2...
[   50.057555] systemd[1]: Expecting device dev-disk-by\x2dlabel-VAR2.device - /dev/disk/by-label/VAR2...
[   50.061580] systemd[1]: Expecting device dev-disk-by\x2duuid-6a3619bf\x2d4d3a\x2d4ecd\x2d8e24\x2d937668d768bb.device - 
/dev/disk/by-uuid/6a3619bf-4d3a-4ecd-8e24-937668d768bb...
[   50.073643] systemd[1]: Expecting device dev-disk-by\x2duuid-6c75bd8e\x2d42fc\x2d47aa\x2d89d2\x2d344399183061.device - 
/dev/disk/by-uuid/6c75bd8e-42fc-47aa-89d2-344399183061...
[   50.081612] systemd[1]: Expecting device dev-tpm0.device - /dev/tpm0...
[   50.089579] systemd[1]: Expecting device dev-ttyS0.device - /dev/ttyS0...
[   50.097749] systemd[1]: Reached target integritysetup.target - Local Integrity Protected Volumes.
[   50.101974] systemd[1]: Reached target nss-user-lookup.target - User and Group Name Lookups.
[   50.105840] systemd[1]: Reached target slices.target - Slice Units.
[   50.109710] systemd[1]: Reached target stunnel.target - TLS tunnels for network services - per-config-file target.
[   50.117856] systemd[1]: Reached target veritysetup.target - Local Verity Protected Volumes.
[   50.132432] systemd[1]: Listening on rpcbind.socket - RPCbind Server Activation Socket.
[   50.146989] systemd[1]: Listening on syslog.socket - Syslog Socket.
[   50.161804] systemd[1]: Listening on systemd-fsckd.socket - fsck to fsckd communication Socket.
[   50.166064] systemd[1]: Listening on systemd-initctl.socket - initctl Compatibility Named Pipe.
[   50.178444] systemd[1]: Listening on systemd-journald-dev-log.socket - Journal Socket (/dev/log).
[   50.181270] systemd[1]: Listening on systemd-journald.socket - Journal Socket.
[   50.200228] systemd[1]: Listening on systemd-udevd-control.socket - udev Control Socket.
[   50.206576] systemd[1]: Listening on systemd-udevd-kernel.socket - udev Kernel Socket.
[   50.253589] systemd[1]: Mounting dev-hugepages.mount - Huge Pages File System...
[   50.282524] systemd[1]: Mounting dev-mqueue.mount - POSIX Message Queue File System...
[   50.294271] systemd[1]: Mounting proc-fs-nfsd.mount - NFSD configuration filesystem...
[   50.307189] systemd[1]: Mounting sys-kernel-debug.mount - Kernel Debug File System...
[   50.310152] systemd[1]: sys-kernel-tracing.mount - Kernel Trace File System was skipped because of an unmet condition check 
(ConditionPathExists=/sys/kernel/tracing).
[   50.322840] systemd[1]: auth-rpcgss-module.service - Kernel Module supporting RPCSEC_GSS was skipped because of an unmet condition check 
(ConditionPathExists=/etc/krb5.keytab).
[   50.356622] systemd[1]: Starting ifupdown-wait-online.service - Wait for network to be configured by ifupdown...
[   50.372086] systemd[1]: Starting kmod-static-nodes.service - Create List of Static Device Nodes...
[   50.426242] systemd[1]: Starting modprobe@configfs.service - Load Kernel Module configfs...
[   50.444587] systemd[1]: Starting modprobe@dm_mod.service - Load Kernel Module dm_mod...
[   50.484066] systemd[1]: Starting modprobe@drm.service - Load Kernel Module drm...
[   50.543965] systemd[1]: Starting modprobe@efi_pstore.service - Load Kernel Module efi_pstore...
[   50.549551] nfsd alternatives: applied 0 out of 48 patches
[   50.594463] systemd[1]: Starting modprobe@fuse.service - Load Kernel Module fuse...
[   50.614184] systemd[1]: Starting modprobe@loop.service - Load Kernel Module loop...
[   50.617276] systemd[1]: systemd-fsck-root.service - File System Check on Root Device was skipped because of an unmet condition check 
(ConditionPathExists=!/run/initramfs/fsck-root).
[   50.627956] systemd[1]: systemd-journald.service: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[   50.653359] systemd[1]: systemd-journald.service: (This warning is only shown for the first unit using IP firewalling.)
[   50.716901] systemd[1]: Starting systemd-journald.service - Journal Service...
[   50.778861] dax alternatives: applied 0 out of 6 patches
[   50.805091] systemd[1]: Starting systemd-modules-load.service - Load Kernel Modules...
[   50.819022] systemd[1]: Starting systemd-remount-fs.service - Remount Root and Kernel File Systems...
[   50.986318] systemd[1]: Starting systemd-udev-trigger.service - Coldplug All udev Devices...
[   50.990312] loop alternatives: applied 0 out of 3 patches
[   51.026332] systemd[1]: Mounted dev-hugepages.mount - Huge Pages File System.
[   51.065412] systemd[1]: Mounted dev-mqueue.mount - POSIX Message Queue File System.
[   51.069845] systemd[1]: Mounted proc-fs-nfsd.mount - NFSD configuration filesystem.
[   51.069845] systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug File System.
[   51.070464] fuse alternatives: applied 0 out of 33 patches
[   51.072740] systemd[1]: Finished kmod-static-nodes.service - Create List of Static Device Nodes.
[   51.093375] fuse: init (API version 7.37)
[   51.148156] dm_mod alternatives: applied 0 out of 9 patches
[   51.171925] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[   51.175762] loop: module loaded
[   51.174167] systemd[1]: Finished modprobe@configfs.service - Load Kernel Module configfs.
[   51.199471] device-mapper: uevent: version 1.0.3
[   51.204170] systemd[1]: modprobe@drm.service: Deactivated successfully.
[   51.209393] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28) initialised: dm-devel@redhat.com
[   51.209176] systemd[1]: Finished modprobe@drm.service - Load Kernel Module drm.
[   51.221047] systemd[1]: modprobe@dm_mod.service: Deactivated successfully.
[   51.226699] systemd[1]: Finished modprobe@dm_mod.service - Load Kernel Module dm_mod.
[   51.232439] systemd[1]: modprobe@efi_pstore.service: Deactivated successfully.
[   51.285986] systemd[1]: Finished modprobe@efi_pstore.service - Load Kernel Module efi_pstore.
[   51.292233] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[   51.297245] systemd[1]: Finished modprobe@fuse.service - Load Kernel Module fuse.
[   51.305086] systemd[1]: modprobe@loop.service: Deactivated successfully.
[   51.306072] systemd-journald[880]: Collecting audit messages is disabled.
[   51.310592] systemd[1]: Finished modprobe@loop.service - Load Kernel Module loop.
[   51.373718] systemd[1]: Mounting sys-fs-fuse-connections.mount - FUSE Control File System...
[   51.374809] systemd[1]: sys-kernel-config.mount - Kernel Configuration File System was skipped because of an unmet condition check 
(ConditionPathExists=/sys/kernel/config).
[   51.384382] systemd[1]: systemd-repart.service - Repartition Root Disk was skipped because no trigger condition checks were met.
[   51.435881] systemd[1]: Starting systemd-tmpfiles-setup-dev-early.service - Create Static Device Nodes in /dev gracefully...
[   51.447613] systemd[1]: Finished systemd-remount-fs.service - Remount Root and Kernel File Systems.
[   51.827631] ipmi_msghandler alternatives: applied 0 out of 23 patches
[   51.849377] IPMI message handler: version 39.2
[   51.863816] systemd[1]: systemd-hwdb-update.service - Rebuild Hardware Database was skipped because of an unmet condition check 
(ConditionNeedsUpdate=/etc).
[   51.870430] systemd[1]: Mounted sys-fs-fuse-connections.mount - FUSE Control File System.
[   51.977350] ipmi device interface
[   52.097360] IPMI poweroff: Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot
[   52.111145] systemd[1]: Started systemd-journald.service - Journal Service.
[   52.201735] ipmi_si alternatives: applied 0 out of 8 patches
[   52.223367] ipmi_si: IPMI System Interface driver
[   52.225524] ipmi_si: Adding device-tree-specified kcs state machine
[   52.225774] ipmi_si: Trying device-tree-specified kcs state machine at mem address 0xfffffff0f05b0000, slave address 0x0, irq 0
[   52.737691] ipmi 16: IPMI message handler: Found new BMC (man_id: 0x00000b, prod_id: 0x8201, dev_id: 0x32)
[   52.837278] IPMI poweroff: ATCA Detect mfg 0xB prod 0x8201
[   52.837363] IPMI poweroff: Found a chassis style poweroff function
[   52.840050] ipmi 16: IPMI kcs interface initialized
[   52.930442] ipmi_watchdog alternatives: applied 0 out of 1 patches
[   53.009282] IPMI Watchdog: driver initialized
[   55.650298] sg alternatives: applied 0 out of 6 patches
[   55.799186] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   55.805868] sd 3:0:0:0: Attached scsi generic sg1 type 0
[   55.811662] ses 3:0:0:1: Attached scsi generic sg2 type 13
[   55.837965] sd 2:0:0:0: Attached scsi generic sg3 type 0
[   55.841839] sd 2:0:1:0: Attached scsi generic sg4 type 0
[   55.842132] sd 4:0:2:0: Attached scsi generic sg5 type 0
[   61.074287] Adding 7815616k swap on /dev/sdd3.  Priority:-2 extents:1 across:7815616k
[   61.566411] XFS (sda1): Mounting V4 Filesystem
[   62.044151] XFS (sda1): Ending clean mount
[   63.057432] jbd2 alternatives: applied 0 out of 21 patches
[   63.054927] ext2 alternatives: applied 0 out of 11 patches
[   63.756883] ext4 alternatives: applied 0 out of 157 patches
[   64.172931] EXT4-fs (sdd6): mounted filesystem with ordered data mode. Quota mode: disabled.
[   64.180907] EXT4-fs (sdd7): mounted filesystem with ordered data mode. Quota mode: disabled.
[   64.549324] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Quota mode: disabled.
[   64.594651] systemd-journald[880]: Received client request to flush runtime journal.
[   64.670396] Adding 41943036k swap on /home/srv/swapfile. Priority:-3 extents:47 across:111984636k
[   65.339616] systemd-journald[880]: /var/log/journal/635c8f65304464a12a0de0cb000042da/system.journal: Journal file uses a different sequence 
number ID, rotating.
[   65.340013] systemd-journald[880]: Rotating system journal.
[   70.198059] tg3 0000:20:02.0 eth0: Link is up at 1000 Mbps, full duplex
[   70.198153] tg3 0000:20:02.0 eth0: Flow control is on for TX and on for RX
[   70.198507] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  107.296340] systemd-journald[880]: /var/log/journal/635c8f65304464a12a0de0cb000042da/user-1000.journal: Journal file uses a different 
sequence number ID, rotating.
[  127.888354] snd alternatives: applied 0 out of 1 patches
[  128.162843] snd_timer alternatives: applied 0 out of 1 patches
[  128.781798] snd_seq alternatives: applied 0 out of 2 patches

Doesn't happen with 6.6.15-parisc64.  I believe 6.1.69+ is okay although this is on a different system.

I believe this impacts performance.

Dave

-- 
John David Anglin  dave.anglin@bell.net


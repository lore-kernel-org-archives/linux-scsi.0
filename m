Received: from pio-pvt-msa1.bahnhof.se (pio-pvt-msa1.bahnhof.se [79.136.2.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5D31A287E;
	Thu, 20 Mar 2025 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.136.2.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742479339; cv=none; b=bAPhJMVoUvLhlPBBsTgPF61E8QJWcEsQQXyt+J+w9vPdmbaNBPtkyX2vk8X5yqRe5lUXo7jn7KiL1ah/JmRBSvTvfcIifq8C2sXBV0Qi/mIMHCkBYm3t3R7Bq0vFy5ecJX6/oP2/4xhehtxAB78CZNZ6M59DFK6fnssv8SgPPgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742479339; c=relaxed/simple;
	bh=4ajJzJE/DHsT5T3CDCsUeZPEGuaC/FCpTnRZbB2JmQY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=YLfNjut3Ot+oc+bbqCoVwo0bc/AAJksHvkXZCjf32vAx/auvAjGTfhlJp2uHuElUei2oC8rsfQJv/GU/U+zkJEkj4VnPgGmiO7XWnE+9QUONUMv5HgZH9I0A46PRx8MWCydEcghk0kcGmLElx0G0xnZfxfysjfG0ZohS6mGAHh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=algiz.nu; spf=pass smtp.mailfrom=algiz.nu; dkim=pass (2048-bit key) header.d=algiz.nu header.i=@algiz.nu header.b=d8tHNXp5; arc=none smtp.client-ip=79.136.2.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=algiz.nu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=algiz.nu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=algiz.nu header.i=@algiz.nu header.b="d8tHNXp5"
Received: from localhost (localhost [127.0.0.1])
	by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTP id 63B363F2C1;
	Thu, 20 Mar 2025 14:55:27 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.1
X-Spam-Level:
Authentication-Results: pio-pvt-msa1.bahnhof.se (amavisd-new);
	dkim=pass (2048-bit key) header.d=algiz.nu
Received: from pio-pvt-msa1.bahnhof.se ([127.0.0.1])
	by localhost (pio-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lRSpCx9pl6Fe; Thu, 20 Mar 2025 14:55:26 +0100 (CET)
Received: 
	by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id C7D563F219;
	Thu, 20 Mar 2025 14:55:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=algiz.nu; s=mail;
	t=1742478924; bh=4ajJzJE/DHsT5T3CDCsUeZPEGuaC/FCpTnRZbB2JmQY=;
	h=Date:To:From:Subject:Cc:From;
	b=d8tHNXp5kVLamMg8xCkYPjtbZ+A1TgzbI1WTpSwTmRr2myj1iXGE4c6XtV1ABMEl1
	 wteWVVLCPfUcYwtyBvvOJsbegQl1yQMgjewyfk0wt+VlHhO0IJDnZsSf4pSliCcJr+
	 oDtElL2KFML7ew6S9kJkbF1Ce9tYVvAlPYdA/qS08y2en3o7VdN9UW9osXwPonxd4s
	 hWVyYO+9ZRhMeF6884mbNwNLKI2awQJb5U5oNwX6Rld9PIY5H0bzg6NaTKJMwfv0fD
	 dFdrGEKHzx1Yie2g4GcrKrAR+o+ye+nn3ZfJRr7UenysuRxs2Iv+mFlwccF0V8b1zS
	 j8/oLy9uw9SoQ==
Received: from [192.168.0.33] (gateway1.intra.algiz.nu [172.18.0.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.intra.algiz.nu (Postfix) with ESMTPSA id 94C415FB08;
	Thu, 20 Mar 2025 13:55:22 +0000 (GMT)
Message-ID: <b35d17b7-2583-479a-b7c7-6bfc9604bc5c@algiz.nu>
Date: Thu, 20 Mar 2025 14:55:16 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: stable@vger.kernel.org
Content-Language: en-US
From: Jarl Gullberg <jarl.gullberg@algiz.nu>
Subject: pm80xx driver crashes in a daisy-chained multipath JBOD configuration
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I'm having issues on kernel 6.12.12 and 6.13.7 with the pm80xx0 driver 
using a PMC/Sierra 8001 card pulled from a SUN/Oracle ZFS Storage 
Appliance. Specifically, the card does not appear to handle 
daisy-chained multipath configurations correctly, and either locks up at 
boot, crashes during runtime, or doesn't enumerate the disks in the 
JBODs correctly. My topology looks like the following:

┌─────────────┐
│    PM8001   │
│ ▒A        ▒ │B
└─║─────────║─┘
   ║         ╚═════╗
┌─║───────────┐   ║
│ ║  JBOD 1   │   ║
│ ║           │   ║
│ ▒ A       ▒ │B  ║
└─║─────────║─┘   ║
┌─║─────────║─┐   ║
│ ║  JBOD 2 ║ │   ║
│ ║         ║ │   ║
│ ▒ A       ▒ │B  ║
└─║─────────║─┘   ║
┌─║─────────║─┐   ║
│ ║  JBOD 3 ║ │   ║
│ ║         ║ │   ║
│ ▒ A       ▒ │B  ║
└───────────║─┘   ║
             ║     ║
             ╚═════╝

Each JBOD has two dual-ported controllers on it, allowing for multiple 
shelves to be chained together and the controlling server to be attached 
at each end. The same topology works with an LSI/Broadcom card.

The problem can be divided into three separate instances:
1 - failure to boot
The driver crashes outright on boot when enumerating disks. Kernel logs 
from 6.13.7: https://gist.github.com/Nihlus/8b390a56ce743a85ff7aaf7b38cb501a

[   15.261604] kernel BUG at drivers/scsi/libsas/sas_scsi_host.c:378!
[   15.335390] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
[   15.402050] CPU: 0 UID: 0 PID: 374 Comm: kworker/0:2 Tainted: 
G        W          6.13-amd64 #1  Debian 6.13.7-1~exp1
[   15.528840] Tainted: [W]=WARN
[   15.564215] Hardware name: SUN MICROSYSTEMS SUN FIRE X4170 M2 
SERVER       /ASSY,MOTHERBOARD,X4170, BIOS 08060108 12/27/2010
[   15.698278] Workqueue: pm80xx pm8001_work_fn [pm80xx]
[   15.758607] RIP: 0010:sas_get_local_phy+0x57/0x60 [libsas]
[   15.824126] Code: 9f 2f 86 e0 48 8b 5b 38 49 89 c4 48 89 df e8 e0 29 
4c e0 4c 89 e6 48 89 ef e8 45 30 86 e0 48 89 d8 5b 5d 41 5c c3 cc cc cc 
cc <0f> 0b 90 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90
[   16.048618] RSP: 0018:ffffaa888e017db0 EFLAGS: 00010246
[   16.111024] RAX: ffff8fe450766408 RBX: ffff8fe4515e3c00 RCX: 
0000000000000002
[   16.196288] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 
ffff8fe4515e3c00
[   16.281552] RBP: ffff8ff5ca075c00 R08: ffff8ff5ca0758c0 R09: 
0000000000000014
[   16.366815] R10: 0000000000000004 R11: 0000000000000000 R12: 
ffff8ff577835200
[   16.452077] R13: ffff8fe450760000 R14: ffff8fe450780e40 R15: 
0000000000000000
[   16.537342] FS:  0000000000000000(0000) GS:ffff8ff577800000(0000) 
knlGS:0000000000000000
[   16.634063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.702706] CR2: 00007fa7f2f58273 CR3: 000000035c022003 CR4: 
00000000000206f0
[   16.787969] Call Trace:
[   16.817136]  <TASK>
[   16.842151]  ? __die_body.cold+0x19/0x27
[   16.888981]  ? die+0x2e/0x50
[   16.923345]  ? do_trap+0xca/0x110
[   16.962909]  ? do_error_trap+0x6a/0x90
[   17.007658]  ? sas_get_local_phy+0x57/0x60 [libsas]
[   17.065922]  ? exc_invalid_op+0x50/0x70
[   17.111710]  ? sas_get_local_phy+0x57/0x60 [libsas]
[   17.169970]  ? asm_exc_invalid_op+0x1a/0x20
[   17.219921]  ? sas_get_local_phy+0x57/0x60 [libsas]
[   17.278184]  pm8001_I_T_nexus_event_handler+0x69/0x1a0 [pm80xx]
[   17.348911]  ? psi_task_switch+0xb7/0x200
[   17.396779]  ? finish_task_switch.isra.0+0x97/0x2c0
[   17.455033]  pm8001_work_fn+0x6b/0x4e0 [pm80xx]
[   17.509144]  ? __schedule+0x50d/0xbf0
[   17.552856]  process_one_work+0x177/0x330
[   17.600721]  worker_thread+0x251/0x390
[   17.645468]  ? __pfx_worker_thread+0x10/0x10
[   17.696455]  kthread+0xd2/0x100
[   17.733933]  ? __pfx_kthread+0x10/0x10
[   17.778683]  ret_from_fork+0x34/0x50
[   17.821360]  ? __pfx_kthread+0x10/0x10
[   17.866107]  ret_from_fork_asm+0x1a/0x30
[   17.912942]  </TASK>
[   17.938987] Modules linked in: usbhid mii hid usb_storage pm80xx ahci 
libsas libahci scsi_transport_sas ixgbe uhci_hcd ehci_pci libata 
ehci_hcd xfrm_algo igb mdio_devres usbcore scsi_mod crc32_pclmul libphy 
e1000e crc32c_intel i2c_i801 i2c_algo_bit i2c_smbus usb_common lpc_ich 
dca scsi_common mdio
[   18.253949] clocksource: Long readout interval, skipping watchdog 
check: cs_nsec: 1981286504 wd_nsec: 1981285958
[   18.375615] ---[ end trace 0000000000000000 ]---

2 - runtime crash
This happens if the cables are reseated or the JBODs restarted after the 
device has successfully booted, usually by leaving the cables unplugged. 
The disk enumeration fails to complete, leading to a call trace in the 
kernel logs and typically causes the JBOD controllers to get stuck in an 
unhealthy state (see case 3). Full kernel logs for 6.12.12 are available 
at https://gist.github.com/Nihlus/cbbabe685de551afa2cc8cdfbc6be6b2 with 
the relevant part being

[  415.245390]  port-0:2:32: trying to add phy phy-0:2:32 fails: it's 
already part of another port
[  415.245473] ------------[ cut here ]------------
[  415.245475] kernel BUG at drivers/scsi/scsi_transport_sas.c:1111!
[  415.245483] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  415.245487] CPU: 0 UID: 0 PID: 11 Comm: kworker/u96:0 Tainted: 
G        W          6.12.12+bpo-amd64 #1  Debian 6.12.12-1~bpo12+1
[  415.245492] Tainted: [W]=WARN
[  415.245493] Hardware name: SUN MICROSYSTEMS SUN FIRE X4170 M2 
SERVER       /ASSY,MOTHERBOARD,X4170, BIOS 08060108 12/27/2010
[  415.245495] Workqueue: 0000:19:00.0_disco_q sas_revalidate_domain 
[libsas]
[  415.245522] RIP: 0010:sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
[  415.245539] Code: d5 75 e8 48 39 c3 74 8e 48 8b 4b 50 48 85 c9 75 03 
48 8b 0b 48 c7 c2 80 c5 46 c0 48 89 ee 48 c7 c7 ae c6 46 c0 e8 5d 32 ce 
c9 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
[  415.245542] RSP: 0018:ffffb595400d3c80 EFLAGS: 00010246
[  415.245544] RAX: 0000000000000000 RBX: ffff905c9651d800 RCX: 
0000000000000027
[  415.245546] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
ffff906db7821780
[  415.245547] RBP: ffff905c96eb4400 R08: 0000000000000000 R09: 
0000000000000003
[  415.245549] R10: ffffb595400d3978 R11: ffff907ffff7ab28 R12: 
ffff905c9651db38
[  415.245550] R13: ffff905c96eb4720 R14: ffff905c96eb4700 R15: 
ffff905c8809a800
[  415.245552] FS:  0000000000000000(0000) GS:ffff906db7800000(0000) 
knlGS:0000000000000000
[  415.245554] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.245556] CR2: 0000557484600000 CR3: 00000002f2622002 CR4: 
00000000000226f0
[  415.245558] Call Trace:
[  415.245562]  <TASK>
[  415.245565]  ? die+0x36/0x90
[  415.245572]  ? do_trap+0xdd/0x100
[  415.245576]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
[  415.245583]  ? do_error_trap+0x6a/0x90
[  415.245585]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
[  415.245592]  ? exc_invalid_op+0x50/0x70
[  415.245597]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
[  415.245603]  ? asm_exc_invalid_op+0x1a/0x20
[  415.245613]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
[  415.245620]  sas_ex_get_linkrate+0x9b/0xd0 [libsas]
[  415.245631]  sas_ex_discover_devices+0x38f/0xc20 [libsas]
[  415.245644]  sas_discover_new+0x71/0x110 [libsas]
[  415.245655]  sas_ex_revalidate_domain+0x337/0x430 [libsas]
[  415.245667]  sas_revalidate_domain+0x189/0x1a0 [libsas]
[  415.245678]  process_one_work+0x17c/0x390
[  415.245685]  worker_thread+0x251/0x360
[  415.245689]  ? __pfx_worker_thread+0x10/0x10
[  415.245692]  kthread+0xd2/0x100
[  415.245695]  ? __pfx_kthread+0x10/0x10
[  415.245698]  ret_from_fork+0x34/0x50
[  415.245702]  ? __pfx_kthread+0x10/0x10
[  415.245704]  ret_from_fork_asm+0x1a/0x30
[  415.245711]  </TASK>
[  415.245712] Modules linked in: binfmt_misc intel_powerclamp coretemp 
kvm_intel kvm joydev evdev crct10dif_pclmul ghash_clmulni_intel 
sha512_ssse3 sha256_ssse3 sha1_ssse3 aesni_intel gf128mul crypto_simd 
cryptd intel_cstate ipmi_ssif ast drm_shmem_helper drm_kms_helper 
iTCO_wdt intel_pmc_bxt intel_uncore iTCO_vendor_support acpi_ipmi 
watchdog pcspkr sg i5500_temp ioatdma acpi_cpufreq i7core_edac ipmi_si 
ipmi_devintf ipmi_msghandler button dm_multipath drm loop efi_pstore 
configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 efivarfs 
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq libcrc32c crc32c_generic raid0 dm_mod raid1 md_mod 
ses enclosure sd_mod hid_generic cdc_ether usbnet uas usbhid mii hid 
usb_storage pm80xx libsas ahci libahci scsi_transport_sas ixgbe libata 
uhci_hcd ehci_pci ehci_hcd xfrm_algo usbcore mdio_devres igb scsi_mod 
e1000e libphy crc32_pclmul crc32c_intel i2c_i801 lpc_ich i2c_smbus 
i2c_algo_bit usb_common scsi_common mdio dca
[  415.245777] ---[ end trace 0000000000000000 ]---
[  415.245778] RIP: 0010:sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
[  415.245785] Code: d5 75 e8 48 39 c3 74 8e 48 8b 4b 50 48 85 c9 75 03 
48 8b 0b 48 c7 c2 80 c5 46 c0 48 89 ee 48 c7 c7 ae c6 46 c0 e8 5d 32 ce 
c9 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
[  415.245788] RSP: 0018:ffffb595400d3c80 EFLAGS: 00010246
[  415.245790] RAX: 0000000000000000 RBX: ffff905c9651d800 RCX: 
0000000000000027
[  415.245791] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
ffff906db7821780
[  415.245793] RBP: ffff905c96eb4400 R08: 0000000000000000 R09: 
0000000000000003
[  415.245794] R10: ffffb595400d3978 R11: ffff907ffff7ab28 R12: 
ffff905c9651db38
[  415.245796] R13: ffff905c96eb4720 R14: ffff905c96eb4700 R15: 
ffff905c8809a800
[  415.245797] FS:  0000000000000000(0000) GS:ffff906db7800000(0000) 
knlGS:0000000000000000
[  415.245800] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.245801] CR2: 0000557484600000 CR3: 00000002f2622002 CR4: 
00000000000226f0
[  415.388491] pm80xx0:: mpi_ssp_completion 1752: status:0x3, tag:0x29b, 
task:0x00000000bc0fdffa

3 - incorrect enumeration
In this case, only disks from JBOD 1 and 2 are enumerated. The device 
boots correctly, but the controllers on the JBODs are in an unhealty 
state and are not forwarding traffic as expected (link LED on A1 to A2 
is dark, link LED on B2 to B3 is dark).

System information:
Linux san1 6.12.12+bpo-amd64 #1 SMP PREEMPT_DYNAMIC Debian 
6.12.12-1~bpo12+1 (2025-02-23) x86_64 GNU/Linux
Kernel config for 6.12.12: 
https://gist.github.com/Nihlus/33ab520b37270ab2d92d2ec26ddfa730
Kernel config for 6.13.7: 
https://gist.github.com/Nihlus/8d1af8204b0e4c456aeb30d079659712


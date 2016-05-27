From: Oleg Borisenko <al@somestuff.ru>
Subject: Re: iscsi fails to attach to targets with kernel 4.4.0
Date: Fri, 27 May 2016 12:04:04 +0000 (UTC)
Message-ID: <loom.20160527T135735-602@post.gmane.org>
References: <2acfbcaeef464e1f86184809ce5157e0@XCH-ALN-006.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33715 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbcE0MFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2016 08:05:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1b6GVk-0004Nv-Gh
	for linux-scsi@vger.kernel.org; Fri, 27 May 2016 14:05:04 +0200
Received: from bran.ispras.ru ([83.149.199.196])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2016 14:05:04 +0200
Received: from al by bran.ispras.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2016 14:05:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm facing the same problem, attaching additional log (maybe it helps)

May 27 07:47:05 oldcompute02 kernel: [ 1168.239065] ------------[ cut here
]------------ May 27 07:47:05 oldcompute02 kernel: [ 1168.239077] WARNING: CPU:
24 PID: 12116 at  /build/linux-lts-xenial-7RlTta/linux-lts-
xenial-4.4.0/fs/sysfs/dir.c:31  sysfs_warn_dup+0x64/0x80() May 27 07:47:05
oldcompute02 kernel: [ 1168.239080] sysfs: cannot create duplicate  filename
'/bus/scsi/devices/11:0:0:0' May 27 07:47:05 oldcompute02 kernel: [ 1168.239082]
Modules linked in: vhost_net vhost  macvtap macvlan veth xt_CHECKSUM
iptable_mangle ipt_MASQUERADE  nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4  xt_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp bridge stp llc ebtable_filter ebtables  ip6table_filter ip6_tables
iptable_filter ip_tables x_tables scsi_dh_alua dm_round_robin  ib_iser rdma_cm
iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi dm_multipath vport_vxlan openvswitch nf_defrag_ipv6
nf_conntrack  bonding binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm  ipmi_ssif ipmi_devintf irqbypass crct10dif_pclmul crc32_pclmul
aesni_intel dcdbas  input_leds joydev cdc_ether usbnet mii aes_x86_64 lrw
gf128mul glue_helper ablk_helper  cryptd acpi_power_meter acpi_pad ipmi_si
ipmi_msghandler 8250_fintek mei_me mei wmi  sb_edac shpchp edac_core lpc_ich
mac_hid lp parport hid_generic bnx2x vxlan  ip6_udp_tunnel ahci usbhid
udp_tunnel ptp hid libahci pps_core megaraid_sas mdio  libcrc32c fjes May 27
07:47:05 oldcompute02 kernel: [ 1168.239182] CPU: 24 PID: 12116 Comm:  iscsiadm
Tainted: G        W       4.4.0-22-generic #40~14.04.1-Ubuntu May 27 07:47:05
oldcompute02 kernel: [ 1168.239185] Hardware name: Dell Inc.  PowerEdge
M620/06GTV1, BIOS 2.5.4 01/27/2016 May 27 07:47:05 oldcompute02 kernel: [
1168.239188]  0000000000000000  ffff881fe34eb9e8 ffffffff813cde6c
ffff881fe34eba30 May 27 07:47:05 oldcompute02 kernel: [ 1168.239192]
ffffffff81ada130 ffff881fe34eba20  ffffffff8107d856 ffff881fe5c2d000 May 27
07:47:05 oldcompute02 kernel: [ 1168.239196]  ffff881fef80b350 ffff883ff1802870
0000000000000001 ffffffffffffffef May 27 07:47:05 oldcompute02 kernel: [
1168.239200] Call Trace: May 27 07:47:05 oldcompute02 kernel: [ 1168.239209]
[<ffffffff813cde6c>]  dump_stack+0x63/0x87 May 27 07:47:05 oldcompute02 kernel:
[ 1168.239216]  [<ffffffff8107d856>]  warn_slowpath_common+0x86/0xc0 May 27
07:47:05 oldcompute02 kernel: [ 1168.239221]  [<ffffffff8107d8dc>]
warn_slowpath_fmt+0x4c/0x50 May 27 07:47:05 oldcompute02 kernel: [ 1168.239225]
[<ffffffff8127a694>]  sysfs_warn_dup+0x64/0x80 May 27 07:47:05 oldcompute02
kernel: [ 1168.239230]  [<ffffffff8127aa2a>]
sysfs_do_create_link_sd.isra.2+0xaa/0xb0 May 27 07:47:05 oldcompute02 kernel: [
1168.239234]  [<ffffffff8127aa55>]  sysfs_create_link+0x25/0x40 May 27 07:47:05
oldcompute02 kernel: [ 1168.239242]  [<ffffffff8152408b>]
bus_add_device+0x10b/0x1f0 May 27 07:47:05 oldcompute02 kernel: [ 1168.239247]
[<ffffffff81521fe5>]  device_add+0x3b5/0x610 May 27 07:47:05 oldcompute02
kernel: [ 1168.239252]  [<ffffffff8158d165>]  scsi_sysfs_add_sdev+0xa5/0x290 May
27 07:47:05 oldcompute02 kernel: [ 1168.239258]  [<ffffffff8158a6e5>]
scsi_probe_and_add_lun+0xb65/0xd80 May 27 07:47:05 oldcompute02 kernel: [
1168.239266]  [<ffffffff8153077c>] ?  __pm_runtime_resume+0x5c/0x70 May 27
07:47:05 oldcompute02 kernel: [ 1168.239271]  [<ffffffff8158b0d2>]
__scsi_scan_target+0xd2/0x230 May 27 07:47:05 oldcompute02 kernel: [
1168.239276]  [<ffffffff8158b307>]  scsi_scan_target+0xd7/0xf0 May 27 07:47:05
oldcompute02 kernel: [ 1168.239293]  [<ffffffffc03fc9d5>]
iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi] May 27
07:47:05 oldcompute02 kernel: [ 1168.239303]  [<ffffffffc03fca10>] ?
iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi] May 27
07:47:05 oldcompute02 kernel: [ 1168.239313]  [<ffffffffc03fca2e>]
iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi] May 27 07:47:05
oldcompute02 kernel: [ 1168.239318]  [<ffffffff81520503>]
device_for_each_child+0x43/0x70 May 27 07:47:05 oldcompute02 kernel: [
1168.239328]  [<ffffffffc03fa82e>]  iscsi_user_scan+0x2e/0x30
[scsi_transport_iscsi] May 27 07:47:05 oldcompute02 kernel: [ 1168.239331]
[<ffffffff8158cf26>]  store_scan+0xa6/0x100 May 27 07:47:05 oldcompute02 kernel:
[ 1168.239338]  [<ffffffff81002d29>] ?  calibrate_delay+0x5b9/0x607 May 27
07:47:05 oldcompute02 kernel: [ 1168.239346]  [<ffffffff811dcc06>] ?
__kmalloc+0x1d6/0x270 May 27 07:47:05 oldcompute02 kernel: [ 1168.239350]
[<ffffffff8151fd38>]  dev_attr_store+0x18/0x30 May 27 07:47:05 oldcompute02
kernel: [ 1168.239354]  [<ffffffff81279dba>]  sysfs_kf_write+0x3a/0x50 May 27
07:47:05 oldcompute02 kernel: [ 1168.239358]  [<ffffffff81279450>]
kernfs_fop_write+0x120/0x170 May 27 07:47:05 oldcompute02 kernel: [ 1168.239364]
[<ffffffff811fd498>]  __vfs_write+0x18/0x40 May 27 07:47:05 oldcompute02 kernel:
[ 1168.239367]  [<ffffffff811fdab2>]  vfs_write+0xa2/0x1a0 May 27 07:47:05
oldcompute02 kernel: [ 1168.239371]  [<ffffffff811fcbf8>] ?
do_sys_open+0x1b8/0x270 May 27 07:47:05 oldcompute02 kernel: [ 1168.239375]
[<ffffffff811fe7d6>]  SyS_write+0x46/0xa0 May 27 07:47:05 oldcompute02 kernel: [
1168.239382]  [<ffffffff817efcf6>]  entry_SYSCALL_64_fastpath+0x16/0x75 May 27
07:47:05 oldcompute02 kernel: [ 1168.239386] ---[ end trace a628d295136d7a5b ]-
-- May 27 07:47:05 oldcompute02 kernel: [ 1168.239432] scsi 11:0:0:0: failed to
add device:  -17 ...skipping... May 27 07:46:49 oldcompute02 kernel: [
1152.208561]  [<ffffffff817efcf6>]  entry_SYSCALL_64_fastpath+0x16/0x75 May 27
07:46:49 oldcompute02 kernel: [ 1152.208595] ---[ end trace a628d295136d7a5a ]-
--





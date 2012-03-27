From: =?UTF-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>
Subject: =?UTF-8?Q?=E7=AD=94=E5=A4=8D:_WARNING:_at_fs/sysfs/inode.c?=
	=?UTF-8?Q?:323_sysfs=5Fhash=5Fand=5Fremove+0xa4/?=
	=?UTF-8?Q?0xb0=28=29?=
Date: Tue, 27 Mar 2012 16:55:54 +0800
Message-ID: <002a01cd0bf7$6b796d40$426c47c0$@com>
References: <005b01cd080a$febd81e0$fc3885a0$@com> <CAA9_cmfJnUYXU9HzBNmruViHagYeyRNtsUm3CtNvotsM0tW2aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45049 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab2C0IzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 04:55:22 -0400
In-Reply-To: <CAA9_cmfJnUYXU9HzBNmruViHagYeyRNtsUm3CtNvotsM0tW2aQ@mail.gmail.com>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

Hi Dan,
	Thanks for your suggest, and I have tested follow your suggest, but st=
ill have problems as follows.

WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb0()
Hardware name: Tylersburg & ICH9/ICH10 Chipset
sysfs: can not remove 'device', no directory
Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_n=
at xt_CHECKSUM iptable_mangle bridge stp llc autofs4 cpufreq_ondemand a=
cpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf=
_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_=
defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mi=
rror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_int=
el kvm uinput ses enclosure sg spcv(O-) libsas scsi_transport_sas serio=
_raw pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support tg3 ioatdma dca i7cor=
e_edac edac_core ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_gene=
ric ata_piix radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core =
[last unloaded: microcode]
Pid: 5, comm: kworker/u:0 Tainted: G        W  O 3.3.0-rc3+ #1
Call Trace:
 [<ffffffff8104b4ff>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104b5f6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff811cf254>] sysfs_hash_and_remove+0xa4/0xb0
 [<ffffffff811d1e16>] sysfs_remove_link+0x26/0x30
 [<ffffffffa0333306>] enclosure_remove_links+0x56/0x80 [enclosure]
 [<ffffffff8123deec>] ? kobject_put+0x2c/0x60
 [<ffffffff8131bf47>] ? put_device+0x17/0x20
 [<ffffffffa0333a41>] enclosure_unregister+0x81/0x200 [enclosure]
 [<ffffffffa03390f2>] ses_intf_remove+0xe2/0xf0 [ses]
 [<ffffffff8131ce19>] device_del+0xc9/0x1d0
 [<ffffffff8131cf42>] device_unregister+0x22/0x60
 [<ffffffff81347825>] __scsi_remove_device+0xb5/0xd0
 [<ffffffff81347870>] scsi_remove_device+0x30/0x50
 [<ffffffff8134795d>] __scsi_remove_target+0xad/0xf0
 [<ffffffff81347a00>] ? scsi_remove_target+0x60/0x60
 [<ffffffff81347a23>] __remove_child+0x23/0x30
 [<ffffffff8131c4cc>] device_for_each_child+0x4c/0x80
 [<ffffffff813479d3>] scsi_remove_target+0x33/0x60
 [<ffffffffa02d7218>] sas_rphy_remove+0x68/0x70 [scsi_transport_sas]
 [<ffffffffa02d7f06>] sas_rphy_delete+0x16/0x30 [scsi_transport_sas]
 [<ffffffffa02e8bc9>] sas_destruct_devices+0x79/0xb0 [libsas]
 [<ffffffffa02e8b50>] ? sas_unregister_common_dev+0x150/0x150 [libsas]
 [<ffffffff81066aa2>] process_one_work+0x132/0x450
 [<ffffffff810688ab>] worker_thread+0x17b/0x3c0
 [<ffffffff81068730>] ? manage_workers+0x220/0x220
 [<ffffffff8106d72e>] kthread+0x9e/0xb0
 [<ffffffff814f20a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106d690>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814f20a0>] ? gs_change+0x13/0x13
---[ end trace 7338fb75a84e74ea ]---
=09
-----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
=E5=8F=91=E4=BB=B6=E4=BA=BA: linux-scsi-owner@vger.kernel.org [mailto:l=
inux-scsi-owner@vger.kernel.org] =E4=BB=A3=E8=A1=A8 Dan Williams
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2012=E5=B9=B43=E6=9C=8824=E6=97=A5=
 2:01
=E6=94=B6=E4=BB=B6=E4=BA=BA: =E4=BA=8E=E7=88=B1=E5=8D=8E
=E6=8A=84=E9=80=81: linux-scsi@vger.kernel.org; James.Bottomley@hansenp=
artnership.com
=E4=B8=BB=E9=A2=98: Re: WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and=
_remove+0xa4/0xb0()

On Thu, Mar 22, 2012 at 2:05 AM, =E4=BA=8E=E7=88=B1=E5=8D=8E <crystal_y=
u@usish.com> wrote:
> Sometimes, when I use rmmod to remove the module of pm8001, I will go=
t problems as follows:
>
>  WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb0()=20
> Hardware name: X7DB8
> sysfs: can not remove 'device', no directory Modules linked in:=20
> raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcp=
y=20
> async_tx ses enclosure spcv(O-) libsas scsi_transport_sas=20
> ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE=20
> iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state=20
> nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter=20
> ip_tables tun autofs4 sunrpc p4_clockmod freq_table speedstep_lib=20
> bridge stp llc ipv6 dm_mirror dm_region_hash dm_log virtio_net virtio=
=20
> virtio_ring kvm_intel kvm microcode pcspkr i2c_i801 sg iTCO_wdt=20
> iTCO_vendor_support i5000_edac edac_core i5k_amb ioatdma dca e1000e=20
> shpchp ext4 mbcache jbd2 floppy sd_mod crc_t10dif pata_acpi=20
> ata_generic ata_piix radeon ttm drm_kms_helper drm i2c_algo_bit=20
> i2c_core dm_mod [last unloaded: mperf]
> Pid: 2835, comm: kworker/u:0 Tainted: G        W  O 3.3.0-rc3+ #2 Cal=
l=20
> Trace:
> [<ffffffff8104c38f>] warn_slowpath_common+0x7f/0xc0=20
> [<ffffffff8104c486>] warn_slowpath_fmt+0x46/0x50 [<ffffffff811d5e04>]=
=20
> sysfs_hash_and_remove+0xa4/0xb0 [<ffffffff811d8ad6>]=20
> sysfs_remove_link+0x26/0x30 [<ffffffffa00192c6>]=20
> enclosure_remove_links+0x56/0x80 [enclosure] [<ffffffff811d805b>] ?=20
> remove_dir+0x3b/0x50 [<ffffffffa001940f>]=20
> enclosure_component_release+0x2f/0x50 [enclosure] [<ffffffff8132c827>=
]=20
> device_release+0x27/0xa0

Hmm, why are we removing links in the release routine, shouldn't they h=
ave been removed before the device was deleted... like what happens in =
enclosure_remove_device()?

This looks like enclosure_remove_links() should be moved from
enclosure_component_release() to enclosure_unregister().

Thoughts?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the body of a message to majordomo@vger.kernel.org More majordomo inf=
o at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

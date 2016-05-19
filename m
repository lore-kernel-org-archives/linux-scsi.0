From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY objects
Date: Thu, 19 May 2016 09:36:44 +0530
Message-ID: <CAK=zhgrVf-eqRELTJNbtNySjPRxqvD4A1kLPkhuE=5=9sDQgiQ@mail.gmail.com>
References: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
	<94D0CD8314A33A4D9D801C0FE68B40296396FB3E@G4W3202.americas.hpqcorp.net>
	<20160516202454.GA2018262@devbig337.prn1.facebook.com>
	<f6e9d525a6435464bfa53bf7884b956f@mail.gmail.com>
	<20160517031357.GA2468135@devbig337.prn1.facebook.com>
	<CAK=zhgov_-ORUsXJexWgJkPs3RMmheaxtGT66skgFBYJRnH3eQ@mail.gmail.com>
	<20160518174917.GA1241608@devbig337.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160518174917.GA1241608@devbig337.prn1.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>
List-Id: linux-scsi@vger.kernel.org

Hi Calvin,

Here is the log w.r.t target drive 2:0:0:0 with your changes,

mpt3sas version 12.100.00.00 unloading
kobject: '2:0:0:0' (ffff8800d50f1010): kobject_uevent_env
kobject: '2:0:0:0' (ffff8800d50f1010): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/bsg/2:0:0:0'
kobject: 'bsg' (ffff88011a011780): kobject_cleanup, parent ffff8800d58611a8
kobject: 'bsg' (ffff88011a011780): auto cleanup kobject_del
kobject: 'bsg' (ffff88011a011780): calling ktype release
kobject: 'bsg': free name
kobject: '2:0:0:0' (ffff8800d50f1010): kobject_cleanup, parent           (null)
kobject: '2:0:0:0' (ffff8800d50f1010): calling ktype release
kobject: '2:0:0:0': free name
kobject: 'sg0' (ffff8800d50f1810): kobject_uevent_env
kobject: 'sg0' (ffff8800d50f1810): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/scsi_generic/sg0'
kobject: 'scsi_generic' (ffff88011a011e80): kobject_cleanup, parent
ffff8800d58611a8
kobject: 'scsi_generic' (ffff88011a011e80): auto cleanup kobject_del
kobject: 'scsi_generic' (ffff88011a011e80): calling ktype release
kobject: 'scsi_generic': free name
kobject: 'sg0' (ffff8800d50f1810): kobject_cleanup, parent           (null)
kobject: 'sg0' (ffff8800d50f1810): calling ktype release
kobject: 'sg0': free name
kobject: '(null)' (ffff88011a5af800): kobject_cleanup, parent           (null)
kobject: '(null)' (ffff88011a5af800): calling ktype release
kobject: '(null)' (ffff8800da2a2880): kobject_cleanup, parent           (null)
kobject: '(null)' (ffff8800da2a2880): calling ktype release
kobject: '2:0:0:0' (ffff8800d5861478): kobject_uevent_env
kobject: '2:0:0:0' (ffff8800d5861478): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/scsi_device/2:0:0:0'
kobject: 'scsi_device' (ffff88011a011b00): kobject_cleanup, parent
ffff8800d58611a8
kobject: 'scsi_device' (ffff88011a011b00): auto cleanup kobject_del
kobject: 'scsi_device' (ffff88011a011b00): calling ktype release
kobject: 'scsi_device': free name
kobject: '2:0:0:0' (ffff8800d5861478): kobject_cleanup, parent           (null)
kobject: '2:0:0:0' (ffff8800d5861478): calling ktype release
kobject: '2:0:0:0': free name
kobject: '2:0:0:0' (ffff8800da3de420): kobject_uevent_env
kobject: '2:0:0:0' (ffff8800da3de420): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/scsi_disk/2:0:0:0'
kobject: 'scsi_disk' (ffff8800daa11180): kobject_cleanup, parent
ffff8800d58611a8
kobject: 'scsi_disk' (ffff8800daa11180): auto cleanup kobject_del
kobject: 'scsi_disk' (ffff8800daa11180): calling ktype release
kobject: 'scsi_disk': free name
kobject: 'integrity' (ffff8800d98d2c00): kobject_uevent_env
kobject: 'integrity' (ffff8800d98d2c00): kobject_uevent_env: filter
function caused the event to drop!
kobject: 'integrity' (ffff8800d98d2c00): kobject_cleanup, parent
    (null)
kobject: 'integrity' (ffff8800d98d2c00): does not have a release()
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: 'iosched' (ffff8800d488b410): kobject_uevent_env
kobject: 'iosched' (ffff8800d488b410): kobject_uevent_env: filter
function caused the event to drop!
kobject: 'queue' (ffff8800d9691120): kobject_uevent_env
kobject: 'queue' (ffff8800d9691120): kobject_uevent_env: filter
function caused the event to drop!
kobject: 'holders' (ffff8800dae04000): kobject_cleanup, parent ffff8800d98d2880
kobject: 'holders' (ffff8800dae04000): auto cleanup kobject_del
kobject: 'holders' (ffff8800dae04000): calling ktype release
kobject: (ffff8800dae04000): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (ffff8800d9851740): kobject_cleanup, parent ffff8800d98d2880
kobject: 'slaves' (ffff8800d9851740): auto cleanup kobject_del
kobject: 'slaves' (ffff8800d9851740): calling ktype release
kobject: (ffff8800d9851740): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'sda' (ffff8800d98d2880): kobject_uevent_env
kobject: 'sda' (ffff8800d98d2880): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0/block/sda'
kobject: 'block' (ffff8800d9fe4c80): kobject_cleanup, parent ffff8800d58611a8
kobject: 'block' (ffff8800d9fe4c80): auto cleanup kobject_del
kobject: 'block' (ffff8800d9fe4c80): calling ktype release
kobject: 'block': free name
sd 2:0:0:0: [sda] Synchronizing SCSI cache
sd 2:0:0:0: tag#0 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
sd 2:0:0:0: tag#0 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
sd 2:0:0:0: tag#0 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
sd 2:0:0:0: [sda] Synchronize Cache(10) failed: Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
kobject: '2:0:0:0' (ffff8800da3de420): kobject_cleanup, parent           (null)
kobject: '2:0:0:0' (ffff8800da3de420): calling ktype release
kobject: 'sda' (ffff8800d98d2880): kobject_cleanup, parent           (null)
kobject: 'sda' (ffff8800d98d2880): calling ktype release
kobject: 'sda': free name
kobject: '2:0:0:0': free name
kobject: '2:0:0:0' (ffff8800d58611a8): kobject_uevent_env
kobject: '2:0:0:0' (ffff8800d58611a8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0'
kobject: '8:0' (ffff8800d223d410): kobject_uevent_env
kobject: '8:0' (ffff8800d223d410): fill_kobj_path: path =
'/devices/virtual/bdi/8:0'
kobject: '8:0' (ffff8800d223d410): kobject_cleanup, parent           (null)
kobject: '8:0' (ffff8800d223d410): calling ktype release
kobject: '8:0': free name
kobject: 'target2:0:0' (ffff8800d9615838): kobject_uevent_env
kobject: 'target2:0:0' (ffff8800d9615838): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/target2:0:0'
kobject: '2:0:0:0' (ffff8800d58611a8): kobject_cleanup, parent           (null)
kobject: '2:0:0:0' (ffff8800d58611a8): calling ktype release
kobject: 'queue' (ffff8800d9691120): kobject_cleanup, parent           (null)
kobject: 'queue' (ffff8800d9691120): calling ktype release
kobject: 'iosched' (ffff8800d488b410): kobject_cleanup, parent           (null)
kobject: 'iosched' (ffff8800d488b410): calling ktype release
kobject: 'iosched': free name
kobject: 'queue': free name
kobject: 'target2:0:0' (ffff8800d9615838): kobject_cleanup, parent
      (null)
kobject: 'target2:0:0' (ffff8800d9615838): calling ktype release
kobject: 'target2:0:0': free name
kobject: '2:0:0:0': free name
kobject: 'sas_host2' (ffff8800d485d010): kobject_uevent_env
kobject: 'sas_host2' (ffff8800d485d010): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/bsg/sas_host2'
kobject: 'bsg' (ffff8800d5a3df00): kobject_cleanup, parent ffff8800da5f8218
kobject: 'bsg' (ffff8800d5a3df00): auto cleanup kobject_del
kobject: 'bsg' (ffff8800d5a3df00): calling ktype release
kobject: 'bsg': free name
kobject: 'sas_host2' (ffff8800d485d010): kobject_cleanup, parent
    (null)
kobject: 'sas_host2' (ffff8800d485d010): calling ktype release
kobject: 'sas_host2': free name
kobject: '(null)' (ffff8800d985a6b8): kobject_cleanup, parent           (null)
kobject: '(null)' (ffff8800d985a6b8): calling ktype release
kobject: '(null)' (ffff8800da26dc10): kobject_cleanup, parent           (null)
kobject: '(null)' (ffff8800da26dc10): calling ktype release
kobject: 'host2' (ffff88011a659838): kobject_uevent_env
kobject: 'host2' (ffff88011a659838): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/sas_host/host2'
kobject: 'sas_host' (ffff8800d5a3d680): kobject_cleanup, parent ffff8800da5f8218
kobject: 'sas_host' (ffff8800d5a3d680): auto cleanup kobject_del
kobject: 'sas_host' (ffff8800d5a3d680): calling ktype release
kobject: 'sas_host': free name
kobject: 'host2' (ffff88011a659838): kobject_cleanup, parent           (null)
kobject: 'host2' (ffff88011a659838): calling ktype release
kobject: 'host2': free name
kobject: 'host2' (ffff8800da5f84e8): kobject_uevent_env
kobject: 'host2' (ffff8800da5f84e8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2/scsi_host/host2'
kobject: 'scsi_host' (ffff8800d9c96180): kobject_cleanup, parent
ffff8800da5f8218
kobject: 'scsi_host' (ffff8800d9c96180): auto cleanup kobject_del
kobject: 'scsi_host' (ffff8800d9c96180): calling ktype release
kobject: 'scsi_host': free name
kobject: 'host2' (ffff8800da5f84e8): kobject_cleanup, parent           (null)
kobject: 'host2' (ffff8800da5f84e8): calling ktype release
kobject: 'host2': free name
kobject: 'host2' (ffff8800da5f8218): kobject_uevent_env
kobject: 'host2' (ffff8800da5f8218): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:07.0/host2'
mpt3sas_cm0: _scsih_remove_device: enter: handle(0x0019),
sas_addr(0x5000c500001e1d11)
mpt3sas_cm0: _scsih_remove_device: enter: enclosure logical
id(0x500605b077777778), slot(4)
mpt3sas_cm0: _scsih_remove_device: enter: enclosure level(0x0000),
connector name(     )
 port-2:0: remove: sas_addr(0x5000c500001e1d11), phy(4)
------------[ cut here ]------------
WARNING: CPU: 7 PID: 3953 at fs/sysfs/group.c:237 sysfs_remove_group+0x97/0xa0
sysfs group ffffffff81ccdac0 not found for kobject 'end_device-2:0'
Modules linked in: mpt3sas(OE-) ip6table_filter ip6_tables ebtable_nat
ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle iptable_filter
ip_tables bridge stp llc nfsd lockd grace nfs_acl auth_rpcgss autofs4
sunrpc ipv6 dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan
vhost tun uinput sg sd_mod scsi_transport_sas raid_class
virtio_balloon snd_hda_codec_generic pcspkr snd_hda_intel
snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm
snd_timer snd soundcore i2c_piix4 i2c_core 8139too 8139cp mii
dm_mod(E) ext4(E) mbcache(E) jbd2(E) virtio_blk(E) virtio_pci(E)
virtio_ring(E) virtio(E) pata_acpi(E) ata_generic(E) ata_piix(E) [last
unloaded: mpt3sas]
CPU: 7 PID: 3953 Comm: rmmod Tainted: G        W  OE   4.6.0+ #2
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
 0000000000000000 ffff8800d224b978 ffffffff812d93b9 ffffffff81248b57
 ffff8800d224b9d8 ffff8800d224b9d8 0000000000000000 ffff8800d224b9c8
 ffffffff8106597d ffff8800d224b9a8 000000edd9d8fe10 ffff8800d224b9b8
Call Trace:
 [<ffffffff812d93b9>] dump_stack+0x51/0x78
 [<ffffffff81248b57>] ? sysfs_remove_group+0x97/0xa0
 [<ffffffff8106597d>] __warn+0xfd/0x120
 [<ffffffff81065a59>] warn_slowpath_fmt+0x49/0x50
 [<ffffffff812448c3>] ? kernfs_find_and_get_ns+0x53/0x70
 [<ffffffff81248b57>] sysfs_remove_group+0x97/0xa0
 [<ffffffff814000aa>] dpm_sysfs_remove+0x5a/0x70
 [<ffffffff813f4189>] device_del+0x49/0x200
 [<ffffffff812daceb>] ? idr_remove+0x4b/0x110
 [<ffffffff813f4362>] device_unregister+0x22/0x60
 [<ffffffff812c6ef2>] bsg_unregister_queue+0x62/0xa0
 [<ffffffffa026b1d2>] sas_rphy_remove+0x42/0x80 [scsi_transport_sas]
 [<ffffffffa026bc96>] sas_rphy_delete+0x16/0x30 [scsi_transport_sas]
 [<ffffffffa026bcda>] sas_port_delete+0x2a/0x120 [scsi_transport_sas]
 [<ffffffffa026b130>] ? sas_port_delete_phy+0x70/0x90 [scsi_transport_sas]
 [<ffffffffa059d8e5>] mpt3sas_transport_port_remove+0x185/0x1c0 [mpt3sas]
 [<ffffffffa0592296>] _scsih_remove_device+0x136/0x330 [mpt3sas]
 [<ffffffff812dbc62>] ? kobj_kset_leave+0x52/0x60
 [<ffffffffa05987a1>] mpt3sas_device_remove_by_sas_address+0xa1/0xe0 [mpt3sas]
 [<ffffffffa0598cd0>] scsih_remove+0xe0/0x1d0 [mpt3sas]
 [<ffffffff8131f4e4>] pci_device_remove+0x44/0xd0
 [<ffffffff8140332e>] ? __pm_runtime_idle+0x8e/0x90
 [<ffffffff813f7c94>] __device_release_driver+0xb4/0x160
 [<ffffffff813f8b2e>] driver_detach+0xbe/0xc0
 [<ffffffff813f6a39>] bus_remove_driver+0x59/0xc0
 [<ffffffff813f90b0>] driver_unregister+0x30/0x60
 [<ffffffff8131f5c3>] pci_unregister_driver+0x23/0x80
 [<ffffffffa05a6b29>] _mpt3sas_exit+0x25/0x38 [mpt3sas]
 [<ffffffff810e7ba3>] SyS_delete_module+0x183/0x1d0
 [<ffffffff81106e20>] ? __audit_syscall_entry+0xb0/0x110
 [<ffffffff81002426>] ? do_audit_syscall_entry+0x66/0x70
 [<ffffffff81002457>] ? syscall_trace_enter_phase1+0x27/0x30
 [<ffffffff810028f3>] ? syscall_trace_enter+0x43/0x70
 [<ffffffff81002d4d>] do_syscall_64+0x6d/0x160
 [<ffffffff8100238c>] ? prepare_exit_to_usermode+0xbc/0xf0
 [<ffffffff8160ec7c>] entry_SYSCALL64_slow_path+0x25/0x25
---[ end trace 7c767b1804b8a6d5 ]---
kobject: 'end_device-2:0' (ffff8800dad0c010): kobject_uevent_env
kobject: 'end_device-2:0' (ffff8800dad0c010): fill_kobj_path: path =
'/host2/port-2:0/end_device-2:0/bsg/end_device-2:0'
kobject: 'bsg' (ffff8800d9fe4180): kobject_cleanup, parent ffff8800da435c10
kobject: 'bsg' (ffff8800d9fe4180): auto cleanup kobject_del
kobject: 'bsg' (ffff8800d9fe4180): calling ktype release
kobject: 'bsg': free name
kobject: 'end_device-2:0' (ffff8800dad0c010): kobject_cleanup, parent
         (null)
kobject: 'end_device-2:0' (ffff8800dad0c010): calling ktype release
kobject: 'end_device-2:0': free name
.....

~Sreekanth

On Wed, May 18, 2016 at 11:19 PM, Calvin Owens <calvinowens@fb.com> wrote:
> On Wednesday 05/18 at 18:44 +0530, Sreekanth Reddy wrote:
>> On Tue, May 17, 2016 at 8:43 AM, Calvin Owens <calvinowens@fb.com> wrote:
>> > On Monday 05/16 at 15:51 -0600, Sathya Prakash Veerichetty wrote:
>> >> Our understanding is the relationship between the SCSI host and SAS end
>> >> devices is a parent-child and before ripping of SCSI host we need to rip of
>> >> all the children.
>> >
>> > I know at least HPSA does the opposite, Elliott observes that other
>> > drivers do as well.
>> >
>> >> Why the enclosure ends up trying to re-parent the SCSI device from the
>> >> enclosure to the SAS PHY even after we remove the SAS Phy?
>> >
>> > Take this path in /sys:
>> >
>> > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/end_device-6:0:0/target6:0:0/6:0:0:0/scsi_device/6:0:0:0
>> >
>> > The problem is "port-6:0:0" in the hierarchy: since mpt3sas explicitly
>> > calls sas_port_delete() before scsi_remove_host(), that node is removed
>> > from the device hierarchy and seems to orphan what lies beneath it:
>> >
>> > [  955.119328] kobject: '6:0:0:0' (ffff88074e2e1008): kobject_uevent_env
>> > [  955.133890] kobject: '6:0:0:0' (ffff88074e2e1008): fill_kobj_path: path = '/end_device-6:0:0/target6:0:0/6:0:0:0/bsg/6:0:0:0'
>> > <WARN/OOPS sadness follows>
>>
>> [Sreekanth] Calvin, Now with your patch we are observing same type of
>> <WARN/OOPS> while unregistered the drive with scsi_transport layer
>> after calling scsi_remove_host() on the same driver unload path,
>>
>> kobject: 'end_device-2:0' (ffff8800dad0c010): kobject_uevent_env
>> kobject: 'end_device-2:0' (ffff8800dad0c010): fill_kobj_path: path =
>> '/host2/port-2:0/end_device-2:0/bsg/end_device-2:0'
>>
>> As scsi_remove_host() has freed it's parent
>> "/devices/pci0000:00/0000:00:07.0" we are observing these warnings.
>>
>> here is it's complete path
>>
>>  fill_kobj_path: path =
>> '/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/bsg/end_device-2:0',
>
> Could you post the stacktraces for your WARN/OOPS?
>
>> Until on  ~3.19/4.0 kernel all the thing are working fine, we haven't
>> seen these types of kernel warning. Also we haven't done any changes
>> in mpt3sas driver w.r.t to this after 4.0 kernel.
>
> I'll dig around more. In any case, my patch seems to be papering over
> the problem rather than solving it, so we need a different fix.
>
> Thanks,
> Calvin
>
>> >
>> > As the above from CONFIG_DEBUG_KOBJECT suggests, "end_device-6:0:0" no longer
>> > has a parent. The path to the enclosured device is:
>> >
>> > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:15/end_device-6:0:15/target6:0:15/6:0:15:0/enclosure/6:0:15:0/ArrayDevice09
>> >
>> > Enclosure wants to re-add the device outside the enclosure:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/misc/enclosure.c#n404
>> >
>> > We melt when trying to re-add "ArrayDevice09" to the "6:0:15:0" directory
>> > above the "enclosure" directory best I can tell. This is *incredibly*
>> > confusing because kobj_add_internal() actually clobbers the parent pointer
>> > if it's NULL:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/lib/kobject.c#n216
>> >
>> > So even though it appears that the parent was "6:0:15:0" here, it was
>> > actually NULL when passed into kobj_add_internal(). Thus, we try to do
>> > the add with the kset as our parent, and we get -ENOENT because that
>> > node has been marked as inactive in kernfs as per here:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/kernfs/dir.c#n743
>> >
>> > Why is it inactive? I think, because __kernfs_remove() deleted an ancestor:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/kernfs/dir.c#n1243
>> >
>> > ...which brings us full circle.
>> >
>> >> Doesn't this need to be taken care in enclosure_removal?
>> >
>> > Even with enclosure compiled out, I still get a WARN like the following
>> > for every block device being removed at rmmod (-dirty here is just from me
>> > applying a fix to SES I sent to the list a few days ago):
>> >
>> > [  224.057286] ------------[ cut here ]------------
>> > [  224.067696] WARNING: CPU: 1 PID: 5412 at fs/sysfs/group.c:237 sysfs_remove_group+0x10f/0x150
>> > [  224.088007] sysfs group ffffffff83109ba0 not found for kobject 'sdc'
>> > [  224.102283] Modules linked in: mpt3sas(-) <snip>
>> > [  224.200483] CPU: 0 PID: 5412 Comm: rmmod Not tainted 4.6.0-dirty #4
>> > [  224.219797] Hardware name: Wiwynn   HoneyBadger/PantherPlus, BIOS HBM6.71 02/03/2016
>> > [  224.237001]  ffffffff82af6280 ffff8806e826f8b0 ffffffff81e13e54 ffff8806e826f928
>> > [  224.253811]  0000000000000000 ffff8806e826f8f8 ffffffff81127822 ffffffff831a5968
>> > [  224.270647]  ffff8806000000ed ffffed00dd04df21 0000000000000000 ffff880754ae3078
>> > [  224.287462] Call Trace:
>> > [  224.292953]  [<ffffffff81e13e54>] dump_stack+0x68/0x94
>> > [  224.304433]  [<ffffffff81127822>] __warn+0x172/0x1b0
>> > [  224.315514]  [<ffffffff811278f7>] warn_slowpath_fmt+0x97/0xb0
>> > [  224.351845]  [<ffffffff816bbc1f>] sysfs_remove_group+0x10f/0x150
>> > [  224.365252]  [<ffffffff81377814>] blk_trace_remove_sysfs+0x14/0x20
>> > [  224.379021]  [<ffffffff81d966bf>] blk_unregister_queue+0xcf/0x120
>> > [  224.392589]  [<ffffffff81dc8c7e>] del_gendisk+0x26e/0x600
>> > [  224.432345]  [<ffffffff8215ea75>] sd_remove+0xf5/0x1b0
>> > [  224.443808]  [<ffffffff820dd210>] __device_release_driver+0x160/0x3a0
>> > [  224.458151]  [<ffffffff820dd475>] device_release_driver+0x25/0x40
>> > [  224.471734]  [<ffffffff820dbd81>] bus_remove_device+0x2e1/0x4b0
>> > [  224.484926]  [<ffffffff820d25ad>] device_del+0x37d/0x680
>> > [  224.555423]  [<ffffffff82148225>] __scsi_remove_device+0x1e5/0x250
>> > [  224.569196]  [<ffffffff821443bc>] scsi_forget_host+0x12c/0x1e0
>> > [  224.582197]  [<ffffffff82120b6c>] scsi_remove_host+0x10c/0x300
>> > [  224.595227]  [<ffffffffa0066cc9>] scsih_remove+0x339/0x670 [mpt3sas]
>> > [  224.609383]  [<ffffffff81edd400>] pci_device_remove+0x70/0x110
>> > [  224.622379]  [<ffffffff820dd210>] __device_release_driver+0x160/0x3a0
>> > [  224.636724]  [<ffffffff820de7b3>] driver_detach+0x183/0x200
>> > [  224.649166]  [<ffffffff820dc61f>] bus_remove_driver+0xdf/0x200
>> > [  224.662185]  [<ffffffff820df2e7>] driver_unregister+0x67/0xa0
>> > [  224.675009]  [<ffffffff81edb2ee>] pci_unregister_driver+0x1e/0xe0
>> > [  224.688613]  [<ffffffffa0093a3a>] _mpt3sas_exit+0x23/0x5e9 [mpt3sas]
>> > [  224.702782]  [<ffffffff812a2d1b>] SyS_delete_module+0x2eb/0x390
>> > [  224.743359]  [<ffffffff829529e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
>> > [  224.759036] ---[ end trace 13f1919bf2ec7bb0 ]---
>> >
>> > My patch fixes that too :)
>> >
>> > The only driver besides mpt*sas that calls sas_delete_port() explicitly is
>> > HPSA, and it does it in the opposite order mpt3sas does: scsi_remove_host()
>> > first.
>> >
>> > Thanks,
>> > Calvin
>> >
>> >> -----Original Message-----
>> >> From: Calvin Owens [mailto:calvinowens@fb.com]
>> >> Sent: Monday, May 16, 2016 2:25 PM
>> >> To: Elliott, Robert (Persistent Memory)
>> >> Cc: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
>> >> Bottomley; Martin K. Petersen; MPT-FusionLinux.pdl@broadcom.com;
>> >> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
>> >> kernel-team@fb.com; calvinowens@fb.com
>> >> Subject: Re: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
>> >> objects
>> >>
>> >> On Friday 05/13 at 21:17 +0000, Elliott, Robert (Persistent Memory) wrote:
>> >> >
>> >> >
>> >> > > -----Original Message-----
>> >> > > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> >> > > owner@vger.kernel.org] On Behalf Of Calvin Owens
>> >> > > Sent: Friday, May 13, 2016 3:28 PM
>> >> > ...
>> >> > > Subject: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS
>> >> > > PHY objects
>> >> > >
>> >> > ...
>> >> > > The issue is that enclosure_remove_device() expects to be able to
>> >> > > re-add the device that was previously enclosured: so with SES
>> >> > > running, the order we unwind things matters in a way it otherwise
>> >> > > wouldn't.
>> >> > >
>> >> > > Since mpt3sas deletes the SAS objects before the SCSI hosts,
>> >> > > enclosure ends up trying to re-parent the SCSI device from the
>> >> > > enclosure to the SAS PHY which has already been deleted. This obviously
>> >> > > ends in sadness.
>> >> > >
>> >> > > The fix appears to be simple: just call scsi_remove_host() before we
>> >> > > call
>> >> > > sas_port_delete() and/or sas_remove_host().
>> >> > >
>> >> > ...
>> >> > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> >> > > @@ -8149,6 +8149,8 @@ void scsih_remove(struct pci_dev *pdev)
>> >> > >           _scsih_raid_device_remove(ioc, raid_device);
>> >> > >   }
>> >> > >
>> >> > > + scsi_remove_host(shost);
>> >> > > +
>> >> > >   /* free ports attached to the sas_host */
>> >> > >   list_for_each_entry_safe(mpt3sas_port, next_port,
>> >> > >      &ioc->sas_hba.sas_port_list, port_list) { @@ -8172,7 +8174,6 @@
>> >> > > void scsih_remove(struct pci_dev *pdev)
>> >> > >   }
>> >> > >
>> >> > >   sas_remove_host(shost);
>> >> > > - scsi_remove_host(shost);
>> >> > >   mpt3sas_base_detach(ioc);
>> >> > >   spin_lock(&gioc_lock);
>> >> > >   list_del(&ioc->list);
>> >> >
>> >> > That change matches the pattern of all other drivers calling
>> >> > sas_remove_host, except for one:
>> >> >     drivers/message/fusion/mptsas.c
>> >> >
>> >> > That consensus means this comment in drivers/scsi/scsi_transport_sas.c
>> >> > is wrong:
>> >> >
>> >> > /**
>> >> >  * sas_remove_host  -  tear down a Scsi_Host's SAS data structures
>> >> >  * @shost:      Scsi Host that is torn down
>> >> >  *
>> >> >  * Removes all SAS PHYs and remote PHYs for a given Scsi_Host.
>> >> >  * Must be called just before scsi_remove_host for SAS HBAs.
>> >> >  */
>> >>
>> >> Yes, exactly: that comment appears to be backwards, and as you say most
>> >> drivers appear to do the opposite (I looked at HPSA at least, which calls
>> >> sas_port_delete() before scsi_remove_host()).
>> >>
>> >> I suppose I should send a patch to fix the comment as well? It'd be nice to
>> >> get some testing to be certain I'm not breaking somebody else's setup by
>> >> fixing mine though...
>> >>
>> >> Thanks,
>> >> Calvin

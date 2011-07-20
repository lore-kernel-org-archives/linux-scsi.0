From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#634681: linux-image-2.6.39-2-686-pae: Usb oops with 2.6.39
 (elv_put_request)
Date: Thu, 21 Jul 2011 00:55:37 +0200
Message-ID: <1311202537.1041.53.camel@localhost>
References: <20110719120848.3936.61351.reportbug@lisko>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-6DMMTrB82VJwmr+6pYV1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1GTWzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 18:55:46 -0400
In-Reply-To: <20110719120848.3936.61351.reportbug@lisko>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: 634681@bugs.debian.org, 633890@bugs.debian.org, 631187@bugs.debian.org


--=-6DMMTrB82VJwmr+6pYV1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-07-19 at 15:08 +0300, Touko Korpela wrote:
> Package: linux-2.6
> Version: 2.6.39-3

This is based on stable update 2.6.39.2, which includes a backport of
commit 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae ('block: add proper
state guards to __elv_next_request').

> Severity: important
>=20
> Plug/unplug (interface disconnected)/plug cycle with Huawei E1552 USB 3G =
modem (also emulates cdrom) sometimes causes kernel oops.
> Wlan was disabled at crash time.
> Oops message is at end of this message.
[...]
> Jul 19 14:00:31 lisko kernel: [232636.442489] BUG: unable to handle kerne=
l paging request at 76656463
> Jul 19 14:00:31 lisko kernel: [232636.442677] IP: [<c1140f25>] elv_put_re=
quest+0x5/0x11
> Jul 19 14:00:31 lisko kernel: [232636.442823] *pdpt =3D 0000000032ccb001 =
*pde =3D 0000000000000000=20
> Jul 19 14:00:31 lisko kernel: [232636.442982] Oops: 0000 [#1] SMP=20
> Jul 19 14:00:31 lisko kernel: [232636.443074] last sysfs file: /sys/devic=
es/pci0000:00/0000:00:13.2/class
> Jul 19 14:00:31 lisko kernel: [232636.443238] Modules linked in: ipt_MASQ=
UERADE xt_state ipt_REJECT xt_tcpudp iptable_filter nf_nat_h323 nf_conntrac=
k_h323 nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gr=
e nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_c=
onntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat nf_conntrack_ip=
v4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables ppp_deflate zlib_deflate =
bsd_comp ppp_async crc_ccitt ppp_generic slhc option usb_wwan usbserial sg =
sr_mod cdrom nls_utf8 nls_cp437 vfat fat bridge stp bnep rfcomm powernow_k8=
 mperf cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservati=
ve fuse loop snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel arc4 sn=
d_hda_codec snd_hwdep ecb snd_pcm snd_seq joydev brcmsmac(C) mac80211 radeo=
n uvcvideo ttm videodev media drm_kms_helper snd_timer snd_seq_device drm s=
nd soundcore snd_page_alloc i2c_algo_bit btusb cfg80211 bluetooth i2c_piix4=
 psmouse serio_raw evdev shpchp tpm_tis tpm battery v
> Jul 19 14:00:31 lisko kernel: ideo tpm_bios samsung_laptop processor butt=
on ac i2c_core power_supply rfkill pcspkr k10temp pci_hotplug ext4 mbcache =
jbd2 crc16 sd_mod usb_storage crc_t10dif uas ahci libahci libata ohci_hcd e=
hci_hcd usbcore scsi_mod thermal sky2 thermal_sys [last unloaded: scsi_wait=
_scan]
> Jul 19 14:00:31 lisko kernel: [232636.444009]=20
> Jul 19 14:00:31 lisko kernel: [232636.444009] Pid: 9956, comm: hald-probe=
-stor Tainted: G        WC   2.6.39-2-686-pae #1 SAMSUNG ELECTRONICS CO., L=
TD. X125                       /X125                      =20
> Jul 19 14:00:31 lisko kernel: [232636.444009] EIP: 0060:[<c1140f25>] EFLA=
GS: 00010006 CPU: 0
> Jul 19 14:00:31 lisko kernel: [232636.444009] EIP is at elv_put_request+0=
x5/0x11
> Jul 19 14:00:31 lisko kernel: [232636.444009] EAX: 7665642f EBX: f763248c=
 ECX: 023a4800 EDX: f2ff1a2c
> Jul 19 14:00:31 lisko kernel: [232636.444009] ESI: f2ff1a2c EDI: 023a4800=
 EBP: f71b7eec ESP: f71b7e4c
> Jul 19 14:00:31 lisko kernel: [232636.444009]  DS: 007b ES: 007b FS: 00d8=
 GS: 00e0 SS: 0068
> Jul 19 14:00:31 lisko kernel: [232636.444009] Process hald-probe-stor (pi=
d: 9956, ti=3Df71b6000 task=3Df4d445e0 task.ti=3Df71b6000)
> Jul 19 14:00:31 lisko kernel: [232636.444009] Stack:
> Jul 19 14:00:31 lisko kernel: [232636.444009]  c1145633 f763248c 00000246=
 f2ff1a2c c1145b27 f2ff1a2c 08000002 f2ff1ace
> Jul 19 14:00:31 lisko kernel: [232636.444009]  f84f824f f73dad40 f71b7eec=
 f4f8a000 f71b7ed4 f84f82ae 00000000 00000000
> Jul 19 14:00:31 lisko kernel: [232636.444009]  f73dad40 000009c4 00000005=
 00000000 00000000 00000003 04000000 f4f8a000
> Jul 19 14:00:31 lisko kernel: [232636.444009] Call Trace:
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c1145633>] ? __blk_put_r=
equest+0x76/0xa1
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c1145b27>] ? blk_put_req=
uest+0x1e/0x2e
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<f84f824f>] ? scsi_execut=
e+0xfc/0x103 [scsi_mod]
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<f84f82ae>] ? scsi_execut=
e_req+0x58/0x83 [scsi_mod]
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<f84f36f9>] ? T.912+0x48/=
0x12c [scsi_mod]
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<f84f382a>] ? scsi_set_me=
dium_removal+0x4d/0x84 [scsi_mod]
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<fa655469>] ? cdrom_relea=
se+0x163/0x1c3 [cdrom]
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c12b1204>] ? __mutex_loc=
k_common+0xf0/0x13a
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<f8766629>] ? sr_block_re=
lease+0x22/0x38 [sr_mod]
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c10ed5e9>] ? __blkdev_pu=
t+0x7c/0x10c
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c10cd743>] ? fput+0xd5/0=
x19d
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c10cae2c>] ? filp_close+=
0x54/0x5a
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c10cae8a>] ? sys_close+0=
x58/0x85
> Jul 19 14:00:31 lisko kernel: [232636.444009]  [<c12b721f>] ? sysenter_do=
_call+0x12/0x28
> Jul 19 14:00:31 lisko kernel: [232636.444009] Code: 74 04 ff d1 89 c3 89 =
d8 5b c3 53 8b 58 0c 8b 1b 8b 5b 30 85 db 74 04 ff d3 eb 09 c7 42 58 00 00 =
00 00 31 c0 5b c3 8b 40 0c 8b 00 <8b> 48 34 85 c9 74 04 89 d0 ff d1 c3 53 8=
b 48 0c 31 db 8b 09 8b=20
> Jul 19 14:00:31 lisko kernel: [232636.444009] EIP: [<c1140f25>] elv_put_r=
equest+0x5/0x11 SS:ESP 0068:f71b7e4c
> Jul 19 14:00:31 lisko kernel: [232636.444009] CR2: 0000000076656463
> Jul 19 14:00:31 lisko kernel: [232636.444009] ---[ end trace 6d450e935ee1=
897e ]---
[...]

Full bug report is at <http://bugs.debian.org/634681>.
Seems to be the same as or similar to <http://bugs.debian.org/633890>,
<http://bugs.debian.org/631187>,
<https://bugs.launchpad.net/debian/+source/linux-2.6/+bug/793796>,
<https://bugzilla.kernel.org/show_bug.cgi?id=3D38842>.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-6DMMTrB82VJwmr+6pYV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATidc3ee/yOyVhhEJAQo8NRAA0VzpzuSC38ZwKUZK2wCYRFU0dvwMV18U
sO2Z/xi1WNFNPtba5Y2zMfkByxeXL0Rmym2T8cc+/0uRLD2buWvH9Q2DU8+SAFwN
31psj3jlB6MiO7gl062KM02+r+SpTQ1f1h7UzH6A+nZ+LyNUrrOAzxMHbkuSWCBP
QdHEyu195FOiG7CCSGGLpUIcs04FPSS/tQQb5vBWPUe/2+NyXVHcu6AOfC9NjNfL
4IyFgOD8Cujtj8y2tLDWUu702xrT0V2q8vCiI/plMAZrmh1ewhN1J49sIgZgS0b1
goFCuqZcOY9Zpy96DgdGBGPBdn2Un2zeLe9Wb6HAF4vh2rL98kUjk42zFlN8MiNJ
oeYHih0/XyY3Gh3P55E6a1oI6534/XWzhh56QITdH5uZpUbG8vpAMvwZH7il6Q8W
3YkmczJeyrCDQSCmZpvqrirqw4j+TQBFyZCV9LzijG824Jn6gH5M4sF24/DSYkQk
GCzJj1FwC7PL/nKPy4JzR6ZBqhvzUyZcadWUSA1z99uZxFlXqrxBalvLCGQfT5Ox
ztuC5XUrxmWwu7JTbjmZXgwjxU81O0olcDA4+nyioXSNE8aHkP0/1y7DtYYY6Ope
J/kbnDwhiELmADcHfmXrDrN0nZYC5q6aoZEOIkGW8ROvLIE/F6aoTQqwcTZed+a0
98wk9ZZQOOs=
=JLZp
-----END PGP SIGNATURE-----

--=-6DMMTrB82VJwmr+6pYV1--

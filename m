Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.202.128.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794878220;
	b=uXwcHWBzMgKN4GryOkvShvVrDsgAOf9bZnYcCqTAZAOWFSTNChGO9E9wMm2w4KtVueGd
	 0YuUlhA62Jg8HHNe/SpzYIHCUr0DxILPJX7PQp4MkWYdT22OWbNAyf0mcxL6j6NYCKPdq
	 jAsRd6onFMLwpSxQEjfmVkbCK+jdJio8fziHqSDP+DQ+fV6Rp4StHp+htT1o4WkcBBWbb
	 +F2XsVKeheRWWYut4ISEH7JZMWHjDpgF/1ve1mFK0HCpXhtxS7g3WCcneB5Qc5MBTCwu/
	 QNZIcc+9CoR6b9VGJ0Oya2ZE4mBrLG1ddamvwmwIzIFu1Cp+Ln1sNSil/1c9Vwz+4CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794878220;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=X+nUfP6dlR0AeNFc4ZQ30zV1RR6mfyZH2qqwq84ynOI=;
	b=DqJiYxJPuGTuo5wyUK9w628ePoXY1SwUvc2A+zSCVKf9CzIuZDGuRN0GOXKdoPTSI1+x
	 ae+GvYEwXqCPeKJ/oLca16wPadtLY2AetwZAsYKm89uRisv4MMTN0Te+7ZNZi8o7GRWPn
	 9pKYrVj9jTlhOgLiqOtXr9oBWdSsXOHkW3hCypLwemQ6SAtsZIcuXtOeH6vXSEHqvfTF1
	 25WY43DCjaquB/495R/jSc/jgN47v8Tp/FPrLjEP9IQe6ryooD7TE+C/3mmupYaQoVo/Y
	 Q65KAytAmjpTWRtSwrLkeTK5iLfpZkPFy3Y7C2CR6jOzG5ZHq1KMd/W0mpvmxz3mBZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=freeshell.de;
	spf=pass smtp.mailfrom=freeshell.de;
	dkim=pass header.d=freeshell.de header.i=@freeshell.de header.a=rsa-sha256 header.s=s2025 header.b="KhS5gxV/";
	arc=none smtp.remote-ip=116.202.128.144
Received: from freeshell.de (freeshell.de [116.202.128.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7554606A31C;
	Tue, 17 Nov 2026 01:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7554606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=freeshell.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freeshell.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freeshell.de header.i=@freeshell.de header.a=rsa-sha256 header.s=s2025 header.b=KhS5gxV/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freeshell.de;
	s=s2025; t=1794878126;
	bh=X+nUfP6dlR0AeNFc4ZQ30zV1RR6mfyZH2qqwq84ynOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KhS5gxV/x4WvML2m+utDjTv9iwRh+57y17gFMflCou32zJQ6NvP5k4s6ja8UVRxsx
	 DptR6aThqIoqvKUXbiK2NTvL6BkEWoCh94TUqzbBwR+ibLEr3PdkLjTZPXghiFD2tO
	 AFiqfcUnkkI5ExEKrQK8ZDVTTJs0c/K6Mj+nZTc/9OYsQS6RUs4CRv5fx6kvi4CbXY
	 uVCqlq7kKlwG9HPSeAusfbkvGRdmVPLI3v/nD6eX+xyLix0spSceLWHHzENfQ+Dj3w
	 uQ31hVI7ET+9rvbaShdw+4gAjoMHKK8F1ERG/GvgWczI3zLGTlJq4lzG59JHEelsfD
	 cPAcvSCqCNH5A==
Received: from [IPV6:2605:59ca:364f:d400:1b91:6b30:22c2:fffc] (unknown [IPv6:2605:59ca:364f:d400:1b91:6b30:22c2:fffc])
	(Authenticated sender: e)
	by freeshell.de (Postfix) with ESMTPSA id 1BA67B22019F;
	Tue, 17 Nov 2026 02:15:20 +0100 (CET)
Message-ID: <8462a0d9-e9b7-467d-b2e1-7870c78e2691@freeshell.de>
Date: Mon, 16 Nov 2026 17:15:08 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/2] Add UFS Host driver support for SpacemiT K3 SoC
To: Yixun Lan <dlan@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Alim Akhtar
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>,
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Jennifer Berringer <jberring@redhat.com>,
 Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org,
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
Content-Language: en-US
From: E Shattow <e@freeshell.de>
In-Reply-To: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Yixun,

On 11/15/26 19:46, Yixun Lan wrote:
> This series try to add UFS support for SpacemiT K3 SoC, the controller
> components consists of System Bus Interface Unit, UFS Host Controller
> Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> Management Entity (DME), Transport Layer, Network Layer, Data Link
> Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
> block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> 
> The DTS patch has been dropped in this series [2], and will send
> in separate series once this patch accepted. For people who want to
> test UFS driver, please grab the DT patch from version v5 [3].
> 
> Enable UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND,
> This allows the device auto-bkops to be always enabled except
> during suspend (both runtime and suspend), with this feature,
> the BKOPS interrupt (log below) isn't reported anymore.
> 
> [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1
> 
> Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
> Link: https://lore.kernel.org/all/20260918-belligerent-succinct-kraken-7fa592@quoll/ [2]
> Link: https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org/ [3]
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
> Changes in v8:
> - enable UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND
> - rename to "ref_clk", see explanation in patch
> - add delay between enable clk & deassert reset
> - respect bRefClkGatingWaitTime, add wait delay
> - drop comment of ufs_hba_spacemit_vops, which got CI complaint
> - rebase to v7.4-rc1
> - Link to v7: https://patch.msgid.link/20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org
> 
> Changes in v7:
> - check err return value of ufs_spacemit_quirk_host_pa_saveconfigtime()
> - Link to v6: https://patch.msgid.link/20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org
> 
> Changes in v6:
> - drop unused macro and dev_req_params
> - use global PX_xx macros
> - fix axi clock name
> - drop dts patch
> - collect tags
> - Link to v5: https://patch.msgid.link/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org
> 
> Changes in v5:
> - adjust clock names
> - add runtime power support
> - collect tags
> - Link to v4: https://patch.msgid.link/20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org
> 
> Changes in v4:
> - fix clock and reset settings
> - drop function which retrieve value of tx_lanes
> - propagate return error of ufs_spacemit_dme_set()
> - check return value ufs_spacemit_check_hibern8()
> - drop call to ufshcd_vops_phy_initialization()
> - handle compiling warning if CONFIG_OF not enabled
>  add __maybe_unused to ufs_spacemit_of_match
> - Link to v3: https://patch.msgid.link/20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org
> 
> Changes in v3:
> - collect tags
> - fix dt-binding warning reported-by sashiko
> - fix low freq in opp-2 table
> - fix err checking in check_hibern8()
> - propagate err code in link_startup_notify()
> - update documents for event_notify()
> - ufs clock driver is merged into v7.3-rc1, update cover letter
> - Link to v2: https://patch.msgid.link/20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org
> 
> Changes in v2:
> - fix missing interrupts property
> - move ufs node to k3-com260.dtsi
> - convert freq-table-hz to operating-points-v2
> - rework reset_control, fix header and drop global variable
> - drop dump_host_regs() debug interface
> - converge and refactor dme_set() operations
> - massive reduce of busy delay() loops
> - drop vendor specific hce_enable_notify(), fallback to default
> - drop unused member from struct ufs_spacemit_host
> - add COMPILE_TEST support to Kconfig
> - comment style fix
> - Link to v1: https://patch.msgid.link/20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org
> 
> ---
> Yixun Lan (2):
>       scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
>       scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> 
>  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
>  drivers/ufs/host/Kconfig                           |  12 +
>  drivers/ufs/host/Makefile                          |   1 +
>  drivers/ufs/host/ufs-spacemit.c                    | 655 +++++++++++++++++++++
>  drivers/ufs/host/ufs-spacemit.h                    |  77 +++
>  5 files changed, 801 insertions(+)
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20260605-08-k3-ufs-support-c8b308e415e2
> 
> Best regards,
> --  
> Yixun Lan <dlan@kernel.org>
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Tested v7 and v8 successfully on Sipeed K3 Pico-ITX (32GiB DRAM / 128GiB
UFS model). Build and test methodology:

### build chimera debian-installer with patched mainline kernel
### assume fresh Debian testing "forky" build environment

apt update
apt install -y b4 bc bison ca-certificates cpio \
 crossbuild-essential-riscv64 curl debhelper fakeroot flex kmod \
 libdw-dev libssl-dev libssl-dev:riscv64 linux-config-7.2:riscv64 \
 python3 rsync

curl -L \
 https://git.kernel.org/torvalds/t/linux-7.4-rc3.tar.gz \
 | tar xz

pushd linux-7.4-rc3
b4 am -v1 -o- \
 https://lore.kernel.org/all/20261115195112.32120-1-e@freeshell.de/ \
 | patch -p1
b4 am -v5 -P3 -o- \
 https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org/ \
 | patch -p1
b4 am -v8 -P1,2 -o- \
 https://lore.kernel.org/linux-riscv/20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org/ \
 | patch -p1
xzcat /usr/src/linux-config-7.2/config.riscv64_none_riscv64.xz \
 > .config
scripts/config \
 --module SCSI_UFS_SPACEMIT \
 --module SCSI_UFSHCD_PLATFORM \
 --module CONFIG_PHY_SPACEMIT_K3_COMBO_PHY \
 --enable DEBUG_INFO_NONE \
 --undefine CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
make ARCH=riscv olddefconfig
make ARCH=riscv KDEB_CHANGELOG_DIST=unreleased LOCALVERSION=-k3ufs \
 -j$(nproc) bindeb-pkg
popd

curl -L \
 https://d-i.debian.org/daily-images/riscv64/daily/netboot/netboot.tar.gz \
 | tar xz ./debian-installer
fakeroot  # enter fakeroot environment to preserve initrd permissions

gzip -dc debian-installer/riscv64/initrd.gz \
 | cpio -id --directory=initrd
dpkg -x linux-image-*k3ufs*_riscv64.deb initrd/custom
gzip -dc initrd/custom/boot/vmlinuz-* \
 > debian-installer/riscv64/linux-custom
mv initrd/lib/modules initrd/custom/
mv initrd/custom/lib/modules initrd/lib/
mv initrd/custom/usr/lib/* debian-installer/device-tree-custom
find initrd -path initrd/custom -prune -o -printf '%P\0' \
 | cpio -0oH newc --directory=initrd \
 | gzip -c > debian-installer/riscv64/initrd-custom.gz

exit  # leave fakeroot environment

pushd debian-installer
tar -czf ../debian-installer-k3ufs.tar.gz \
 --transform 's~^~debian-installer-k3ufs/~' \
 device-tree-custom \
 riscv64/linux-custom \
 riscv64/initrd-custom.gz \
 ../linux-image-*k3ufs*_riscv64.deb
popd

### end (build chimera debian-installer with patched mainline kernel)

Then follow mainline U-Boot/OpenSBI build guide at:
https://lore.kernel.org/u-boot/20261029001555.1890775-1-e@freeshell.de/

with "python3 -m http.server 8000" to serve the files:

u-boot> env set autoload no
u-boot> dhcp
u-boot> wget $kernel_addr_r http://host:8000/riscv64/linux-custom
u-boot> wget $fdt_addr_r
http://host:8000/device-tree-custom/spacemit/k3-pico-itx.dtb
u-boot> wget $ramdisk_addr_r http://host:8000/riscv64/initrd-custom.gz
u-boot> env set bootargs 'console=ttyS0,115200 debug rootwait earlycon=sbi'
u-boot> bootefi $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r

before the very last step of debian-installer to reboot, go to console
screen and use chroot to install the patched kernel to target and copy
out the necessary files

for i in /dev /dev/pts /proc /run /sys /tmp ; do mount -o bind $i
/target$i ; done
chroot /target sh -c 'scp
user@host:/path/to/debian-installer-k3ufs/linux-image-*k3ufs*.deb /tmp'
chroot /target sh -c 'dpkg -i /tmp/linux-image-*k3ufs*.deb'
chroot /target sh -c 'scp /boot/initrd.img-*k3ufs
user@host:/path/to/installed-debiank3'
chroot /target sh -c 'scp /boot/vmlinuz-*k3ufs
user@host:/path/to/installed-debiank3'
chroot /target sh -c 'scp
/lib/linux-image-*k3ufs/spacemit/k3-pico-itx.dtb
user@host:/path/to/installed-debiank3'
chroot /target sh -c 'scp /boot/grub/grub.cfg
user@host:/path/to/installed-debiank3'
for i in /dev/pts /dev /proc /run /sys /tmp ; do umount /target$i ; done

... over network to some host later used to serve the bootloader these
files via "python -m http.server 8000"

u-boot> env set autoload no
u-boot> dhcp
u-boot> wget $kernel_addr_r http://host:8000/vmlinux-7.4.0-rc3-k3ufs
u-boot> wget $fdt_addr_r http://host:8000/k3-pico-itx.dtb
u-boot> wget $ramdisk_addr_r http://host:8000/initrd.img-7.4.0-rc3-k3ufs
u-boot> env set bootargs 'root=UUID=<place UUID here from grub.cfg> ro
quiet'
u-boot> bootefi $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r

Workload for testing is to repeat the above build steps on-device from
UFS-backed root filesystem. In v7 there would be the occasional BKOPS
warnings, and v8 here now no such BKOPS warnings.

I do notice some UFS-related warnings and errors in dmesg:

journalctl --dmesg | grep ufshcd
ufshcd-spacemit c0e00000.ufshc: freq-table-hz property not specified
ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
vdd-hba-supply regulator, assuming enabled
ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
vcc-supply regulator, assuming enabled
ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
vccq-supply regulator, assuming enabled
ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
vccq2-supply regulator, assuming enabled
scsi host0: ufshcd
ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus: BOOT WLUN not found
ufshcd-spacemit c0e00000.ufshc: DL error event, INT errors:0x4,
DL_ERR:0x80000020

-E

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD65AC6FA92
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 21:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiIOVMx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIOVMu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 17:12:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149357B7A0;
        Thu, 15 Sep 2022 14:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663276369; x=1694812369;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Kvh2AgwaqrMB4C+nQ1e/wLqAn9QuX+E5zGP034cyICY=;
  b=i9hHR3KQjCB0/GU0zgH44DCcg6XvUA4zTnJv2d94wnagVWdKyKSDzm0K
   5hXKH6A+2ee8oLMQEaJ1lIeRxrtEFd77NrV2YbtWwCtJUK3LSZWWYrEGs
   o2Uk21OFrqEXURs2AP41BIaBJZKC81wkcZ42rHrLo6VuiXN16ZN4cLLsy
   xJSUcwjvC+V8hEmChj2omOgt85LPf3qJTE7srLOk9sO/iYxp2kcJi4fmx
   /xzt97NBuToKeIVc0ZlhgfutuEwtfIgCQMUjAgHhG2fRVYq8kse44oTTH
   NGPqenblBkc4QXBYXuAqyxEikG64xISyKpR+a8auePhsyoQdkQQZRasC6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="298832762"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="298832762"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 14:12:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="706515815"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2022 14:12:46 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oYwA9-000115-1c;
        Thu, 15 Sep 2022 21:12:45 +0000
Date:   Fri, 16 Sep 2022 05:11:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 6ce5d01e7011b32600656bf90a626b1e51fb192a
Message-ID: <63239512.gzJmoh0vIZ1pxX6C%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6ce5d01e7011b32600656bf90a626b1e51fb192a  Add linux-next specific files for 20220915

Error/Warning reports:

https://lore.kernel.org/linux-mm/202209150141.WgbAKqmX-lkp@intel.com
https://lore.kernel.org/linux-mm/202209150959.hEWCNjXH-lkp@intel.com
https://lore.kernel.org/llvm/202209141913.Nxzv3hwM-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "devm_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_memremap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_memunmap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/char/xillybus/xillybus_of.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/clk/xilinx/clk-xlnx-clock-wizard.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
arch/parisc/lib/iomap.c:363:5: warning: no previous prototype for 'ioread64_lo_hi' [-Wmissing-prototypes]
arch/parisc/lib/iomap.c:373:5: warning: no previous prototype for 'ioread64_hi_lo' [-Wmissing-prototypes]
arch/parisc/lib/iomap.c:448:6: warning: no previous prototype for 'iowrite64_lo_hi' [-Wmissing-prototypes]
arch/parisc/lib/iomap.c:454:6: warning: no previous prototype for 'iowrite64_hi_lo' [-Wmissing-prototypes]
drivers/gpu/drm/drm_atomic_helper.c:802: warning: expecting prototype for drm_atomic_helper_check_wb_connector_state(). Prototype was for drm_atomic_helper_check_wb_encoder_state() instead
drivers/hwmon/emc2305.c:194 emc2305_set_cur_state() warn: impossible condition '(val > 255) => (0-255 > 255)'
drivers/scsi/qla2xxx/qla_os.c:2854:23: warning: assignment to 'struct trace_array *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
drivers/scsi/qla2xxx/qla_os.c:2854:25: error: implicit declaration of function 'trace_array_get_by_name'; did you mean 'trace_array_set_clr_event'? [-Werror=implicit-function-declaration]
drivers/scsi/qla2xxx/qla_os.c:2869:9: error: implicit declaration of function 'trace_array_put' [-Werror=implicit-function-declaration]
make[4]: *** No rule to make target 'drivers/crypto/aspeed/aspeed_crypto.o', needed by 'drivers/crypto/aspeed/built-in.a'.

Unverified Error/Warning (likely false positive, please contact us if interested):

ERROR: modpost: "__tsan_memcpy" [arch/arm64/crypto/sha512-arm64.ko] undefined!
ERROR: modpost: "__tsan_memcpy" [arch/arm64/crypto/sha512-ce.ko] undefined!
ERROR: modpost: "__tsan_memcpy" [fs/binfmt_misc.ko] undefined!
ERROR: modpost: "__tsan_memcpy" [kernel/kcsan/kcsan_test.ko] undefined!
ERROR: modpost: "__tsan_memcpy" [mm/zsmalloc.ko] undefined!
ERROR: modpost: "__tsan_memset" [arch/arm64/crypto/sha512-arm64.ko] undefined!
ERROR: modpost: "__tsan_memset" [arch/arm64/crypto/sha512-ce.ko] undefined!
ERROR: modpost: "__tsan_memset" [fs/binfmt_misc.ko] undefined!
ERROR: modpost: "__tsan_memset" [kernel/scftorture.ko] undefined!
ERROR: modpost: "__tsan_memset" [mm/zsmalloc.ko] undefined!

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|   |-- drivers-scsi-qla2xxx-qla_os.c:error:implicit-declaration-of-function-trace_array_get_by_name
|   |-- drivers-scsi-qla2xxx-qla_os.c:error:implicit-declaration-of-function-trace_array_put
|   `-- drivers-scsi-qla2xxx-qla_os.c:warning:assignment-to-struct-trace_array-from-int-makes-pointer-from-integer-without-a-cast
|-- alpha-randconfig-r013-20220914
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- arc-allyesconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- arc-randconfig-r043-20220914
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- arm-allyesconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- arm-defconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- arm-randconfig-r016-20220914
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- arm64-allyesconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- i386-allyesconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- i386-defconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- i386-randconfig-a003
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- i386-randconfig-a012
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- i386-randconfig-a014
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- i386-randconfig-a016
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- ia64-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_os.c:error:implicit-declaration-of-function-trace_array_get_by_name
|   |-- drivers-scsi-qla2xxx-qla_os.c:error:implicit-declaration-of-function-trace_array_put
|   `-- drivers-scsi-qla2xxx-qla_os.c:warning:assignment-to-struct-trace_array-from-int-makes-pointer-from-integer-without-a-cast
|-- loongarch-buildonly-randconfig-r005-20220914
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- m68k-allmodconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- m68k-allyesconfig
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- m68k-randconfig-c042-20220915
|   `-- make:No-rule-to-make-target-drivers-crypto-aspeed-aspeed_crypto.o-needed-by-drivers-crypto-aspeed-built-in.a-.
|-- m68k-randconfig-r026-20220914
|   `-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|-- microblaze-randconfig-m031-20220915
|   |-- drivers-gpu-drm-display-drm_dp_helper.c-drm_dp_phy_name()-warn:unsigned-dp_phy-is-never-less-than-zero.
|   |-- drivers-gpu-drm-drm_atomic_helper.c:warning:expecting-prototype-for-drm_atomic_helper_check_wb_connector_state().-Prototype-was-for-drm_atomic_helper_check_wb_encoder_state()-instead
|   `-- drivers-hwmon-emc2305.c-emc2305_set_cur_state()-warn:impossible-condition-(val-)-(-)
|-- microblaze-randconfig-r006-20220914
clang_recent_errors
|-- arm64-randconfig-r006-20220915
|   |-- ERROR:__tsan_memcpy-arch-arm64-crypto-sha512-arm64.ko-undefined
|   |-- ERROR:__tsan_memcpy-arch-arm64-crypto-sha512-ce.ko-undefined
|   |-- ERROR:__tsan_memcpy-fs-binfmt_misc.ko-undefined
|   |-- ERROR:__tsan_memcpy-kernel-kcsan-kcsan_test.ko-undefined
|   |-- ERROR:__tsan_memcpy-mm-zsmalloc.ko-undefined
|   |-- ERROR:__tsan_memset-arch-arm64-crypto-sha512-arm64.ko-undefined
|   |-- ERROR:__tsan_memset-arch-arm64-crypto-sha512-ce.ko-undefined
|   |-- ERROR:__tsan_memset-fs-binfmt_misc.ko-undefined
|   |-- ERROR:__tsan_memset-kernel-scftorture.ko-undefined
|   `-- ERROR:__tsan_memset-mm-zsmalloc.ko-undefined
|-- arm64-randconfig-r023-20220914
|   `-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-function-apply_alternatives_vdso
|-- i386-randconfig-a002
|   |-- ERROR:___ratelimit-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:__per_cpu_offset-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:__phys_addr-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:__ubsan_handle_out_of_bounds-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:__warn_printk-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:_printk-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:cpu_number-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:kvm_find_user_return_msr-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:kvm_spurious_fault-arch-x86-kvm-kvm-intel.ko-undefined
|   |-- ERROR:smp_call_function_single-arch-x86-kvm-kvm-intel.ko-undefined
|   `-- drivers-extcon-extcon-usbc-tusb320.c:warning:expecting-prototype-for-drivers-extcon-extcon-tusb320c().-Prototype-was-for-TUSB320_REG8()-instead
|-- i386-randconfig-a015
|   `-- drivers-extcon-extcon-usbc-tusb320.c:warning:expecting-prototype-for-drivers-extcon-extcon-tusb320c().-Prototype-was-for-TUSB320_REG8()-instead
|-- powerpc-mpc832x_mds_defconfig
|   |-- arch-powerpc-math-emu-fcmpu.c:error:variable-A_c-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fcmpu.c:error:variable-B_c-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fcmpu.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fctiw.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fctiwz.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|   `-- arch-powerpc-math-emu-fsel.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|-- powerpc-tqm8560_defconfig
|   |-- arch-powerpc-math-emu-fcmpu.c:error:variable-A_c-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fcmpu.c:error:variable-B_c-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fcmpu.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fctiw.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|   |-- arch-powerpc-math-emu-fctiwz.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|   `-- arch-powerpc-math-emu-fsel.c:error:variable-_fex-set-but-not-used-Werror-Wunused-but-set-variable
|-- riscv-randconfig-r042-20220914
|   |-- arch-riscv-errata-thead-errata.c:error:use-of-undeclared-identifier-riscv_cbom_block_size
|   `-- drivers-extcon-extcon-usbc-tusb320.c:warning:expecting-prototype-for-drivers-extcon-extcon-tusb320c().-Prototype-was-for-TUSB320_REG8()-instead
|-- s390-buildonly-randconfig-r002-20220914
|   |-- arch-s390-mm-maccess.c:warning:no-previous-prototype-for-function-memcpy_real
|   |-- arch-s390-mm-maccess.c:warning:no-previous-prototype-for-function-memcpy_real_init
|   `-- arch-s390-mm-maccess.c:warning:no-previous-prototype-for-function-memcpy_real_iter
|-- s390-randconfig-r012-20220914
|   |-- arch-s390-mm-maccess.c:warning:no-previous-prototype-for-function-memcpy_real

elapsed time: 728m

configs tested: 56
configs skipped: 3

gcc tested configs:
arc                                 defconfig
um                             i386_defconfig
um                           x86_64_defconfig
alpha                               defconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
m68k                             allmodconfig
s390                                defconfig
arc                  randconfig-r043-20220914
arc                              allyesconfig
powerpc                           allnoconfig
s390                             allmodconfig
alpha                            allyesconfig
i386                                defconfig
x86_64                    rhel-8.3-kselftests
i386                          randconfig-a001
i386                          randconfig-a014
m68k                             allyesconfig
x86_64                          rhel-8.3-func
i386                          randconfig-a003
i386                          randconfig-a012
x86_64                              defconfig
arm                                 defconfig
i386                          randconfig-a016
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
s390                             allyesconfig
x86_64                           rhel-8.3-syz
i386                          randconfig-a005
arm                              allyesconfig
arc                               allnoconfig
alpha                             allnoconfig
riscv                             allnoconfig
csky                              allnoconfig
x86_64                               rhel-8.3
sh                               allmodconfig
x86_64                           allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig
arm64                            allyesconfig
i386                             allyesconfig
ia64                             allmodconfig

clang tested configs:
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
riscv                randconfig-r042-20220914
hexagon              randconfig-r045-20220914
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a011
i386                          randconfig-a002
hexagon              randconfig-r041-20220914
i386                          randconfig-a004
i386                          randconfig-a006
s390                 randconfig-r044-20220914

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

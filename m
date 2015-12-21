From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-review:Don-Brace/hpsa-updates/20151222-012604]
 2d6b0344e54718328f78cd942d965f0b4725bd8d BUILD DONE
Date: Tue, 22 Dec 2015 02:12:38 +0800
Message-ID: <56784116.TqFfYYfza2tQlsr1%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14863 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbbLUSNK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2015 13:13:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@parallels.com, elliott@hpe.com, Justin.Lindley@pmcs.com, hch@infradead.org, Mahesh.Rajashekhara@pmcs.com, scott.benesh@pmcs.com, Kevin.Barnett@pmcs.com, scott.teel@pmcs.com, Viswas.G@pmcs.com

https://github.com/0day-ci/linux  Don-Brace/hpsa-updates/20151222-01260=
4
2d6b0344e54718328f78cd942d965f0b4725bd8d  hpsa: add box and bay informa=
tion for enclosure devices

arch/alpha/include/asm/string.h:21:16: error: expected declaration spec=
ifiers before '__builtin_memcpy'
arch/sparc/include/asm/string_64.h:25:25: error: expected declaration s=
pecifiers before '__builtin_memcpy'
arch/x86/include/asm/string_32.h:182:25: error: expected declaration sp=
ecifiers before '__builtin_memcpy'
drivers/scsi/hpsa.c:157:26: warning: 'products' defined but not used [-=
Wunused-variable]
drivers/scsi/hpsa.c:212:40: warning: 'hpsa_sas_transport_template' defi=
ned but not used [-Wunused-variable]
drivers/scsi/hpsa.c:215:12: warning: 'hpsa_add_sas_device' used but nev=
er defined
drivers/scsi/hpsa.c:215:12: warning: 'hpsa_add_sas_device' used but nev=
er defined [enabled by default]
drivers/scsi/hpsa.c:217:13: warning: 'hpsa_remove_sas_device' used but =
never defined
drivers/scsi/hpsa.c:217:13: warning: 'hpsa_remove_sas_device' used but =
never defined [enabled by default]
drivers/scsi/hpsa.c:219:3: warning: 'hpsa_find_device_by_sas_rphy' used=
 but never defined
drivers/scsi/hpsa.c:219:3: warning: 'hpsa_find_device_by_sas_rphy' used=
 but never defined [enabled by default]
drivers/scsi/hpsa.c:226:12: warning: 'number_of_controllers' defined bu=
t not used [-Wunused-variable]
drivers/scsi/hpsa.c:230:12: warning: 'hpsa_ioctl' used but never define=
d
drivers/scsi/hpsa.c:230:12: warning: 'hpsa_ioctl' used but never define=
d [enabled by default]
drivers/scsi/hpsa.c:233:12: warning: 'hpsa_compat_ioctl' used but never=
 defined
drivers/scsi/hpsa.c:233:12: warning: 'hpsa_compat_ioctl' used but never=
 defined [enabled by default]
drivers/scsi/hpsa.c:237:13: warning: 'cmd_free' used but never defined
drivers/scsi/hpsa.c:237:13: warning: 'cmd_free' used but never defined =
[enabled by default]
drivers/scsi/hpsa.c:238:28: warning: 'cmd_alloc' used but never defined
drivers/scsi/hpsa.c:238:28: warning: 'cmd_alloc' used but never defined=
 [enabled by default]
drivers/scsi/hpsa.c:239:13: warning: 'cmd_tagged_free' used but never d=
efined
drivers/scsi/hpsa.c:239:13: warning: 'cmd_tagged_free' used but never d=
efined [enabled by default]
drivers/scsi/hpsa.c:242:12: warning: 'fill_cmd' used but never defined
drivers/scsi/hpsa.c:242:12: warning: 'fill_cmd' used but never defined =
[enabled by default]
drivers/scsi/hpsa.c:249:12: warning: 'hpsa_scsi_queue_command' used but=
 never defined
drivers/scsi/hpsa.c:249:12: warning: 'hpsa_scsi_queue_command' used but=
 never defined [enabled by default]
drivers/scsi/hpsa.c:250:13: warning: 'hpsa_scan_start' used but never d=
efined
drivers/scsi/hpsa.c:250:13: warning: 'hpsa_scan_start' used but never d=
efined [enabled by default]
drivers/scsi/hpsa.c:251:12: warning: 'hpsa_scan_finished' used but neve=
r defined
drivers/scsi/hpsa.c:251:12: warning: 'hpsa_scan_finished' used but neve=
r defined [enabled by default]
drivers/scsi/hpsa.c:253:12: warning: 'hpsa_change_queue_depth' used but=
 never defined
drivers/scsi/hpsa.c:253:12: warning: 'hpsa_change_queue_depth' used but=
 never defined [enabled by default]
drivers/scsi/hpsa.c:255:12: warning: 'hpsa_eh_device_reset_handler' use=
d but never defined
drivers/scsi/hpsa.c:255:12: warning: 'hpsa_eh_device_reset_handler' use=
d but never defined [enabled by default]
drivers/scsi/hpsa.c:256:12: warning: 'hpsa_eh_abort_handler' used but n=
ever defined
drivers/scsi/hpsa.c:256:12: warning: 'hpsa_eh_abort_handler' used but n=
ever defined [enabled by default]
drivers/scsi/hpsa.c:280:20: warning: 'finish_cmd' used but never define=
d
drivers/scsi/hpsa.c:280:20: warning: 'finish_cmd' used but never define=
d [enabled by default]
drivers/scsi/hpsa.c:289:13: warning: 'hpsa_command_resubmit_worker' use=
d but never defined
drivers/scsi/hpsa.c:289:13: warning: 'hpsa_command_resubmit_worker' use=
d but never defined [enabled by default]
drivers/scsi/hpsa.c:3196:13: error: old-style parameter declarations in=
 prototyped function definition
drivers/scsi/hpsa.c:3201:2: error: parameter 'rc' is initialized
drivers/scsi/hpsa.c:3202:9: error: parameter 'c' is initialized
drivers/scsi/hpsa.c:3203:9: error: parameter 'ei' is initialized
drivers/scsi/hpsa.c:3204:9: error: parameter 'bssbp' is initialized
drivers/scsi/hpsa.c:3205:9: error: parameter 'id_phys' is initialized
drivers/scsi/hpsa.c:3206:38: error: 'rlep' undeclared (first use in thi=
s function)
drivers/scsi/hpsa.c:3206:48: error: 'rle_index' undeclared (first use i=
n this function)
drivers/scsi/hpsa.c:3206:9: error: parameter 'rle' is initialized
drivers/scsi/hpsa.c:3207:2: error: parameter 'bmic_device_index' is ini=
tialized
drivers/scsi/hpsa.c:3209:2: error: expected declaration specifiers befo=
re 'bmic_device_index'
drivers/scsi/hpsa.c:3211:2: error: expected declaration specifiers befo=
re 'if'
drivers/scsi/hpsa.c:3211:2: note: in expansion of macro 'if'
drivers/scsi/hpsa.c:3214:2: error: expected declaration specifiers befo=
re 'bssbp'
drivers/scsi/hpsa.c:3218:2: error: expected declaration specifiers befo=
re 'id_phys'
drivers/scsi/hpsa.c:3222:2: error: expected declaration specifiers befo=
re 'rc'
drivers/scsi/hpsa.c:3230:2: error: expected declaration specifiers befo=
re 'c'
drivers/scsi/hpsa.c:3240:2: error: expected declaration specifiers befo=
re 'else'
drivers/scsi/hpsa.c:3248:2: error: expected declaration specifiers befo=
re 'ei'
drivers/scsi/hpsa.c:3254:2: error: expected declaration specifiers befo=
re 'encl_dev'
drivers/scsi/hpsa.c:3255:2: error: expected declaration specifiers befo=
re 'memcpy'
drivers/scsi/hpsa.c:3255:2: note: in expansion of macro 'memcpy'
drivers/scsi/hpsa.c:3259:1: error: expected declaration specifiers befo=
re 'out'
drivers/scsi/hpsa.c:3261:2: error: expected declaration specifiers befo=
re 'kfree'
drivers/scsi/hpsa.c:3269:1: error: expected declaration specifiers befo=
re '}' token
drivers/scsi/hpsa.c:3273:1: error: expected '=3D', ',', ';', 'asm' or '=
__attribute__' before '{' token
drivers/scsi/hpsa.c:884:34: warning: 'hpsa_driver_template' defined but=
 not used [-Wunused-variable]
drivers/scsi/hpsa.c:8873:15: error: parameter 'hpsa_pci_driver' is init=
ialized
drivers/scsi/hpsa.c:8873:26: error: storage class specified for paramet=
er 'hpsa_pci_driver'
drivers/scsi/hpsa.c:8875:11: error: 'hpsa_init_one' undeclared (first u=
se in this function)
drivers/scsi/hpsa.c:8876:12: error: 'hpsa_remove_one' undeclared (first=
 use in this function)
drivers/scsi/hpsa.c:8878:14: error: 'hpsa_shutdown' undeclared (first u=
se in this function)
drivers/scsi/hpsa.c:8879:13: error: 'hpsa_suspend' undeclared (first us=
e in this function)
drivers/scsi/hpsa.c:8880:12: error: 'hpsa_resume' undeclared (first use=
 in this function)
drivers/scsi/hpsa.c:9647:15: error: parameter 'hpsa_sas_transport_funct=
ions' is initialized
drivers/scsi/hpsa.c:9647:37: error: storage class specified for paramet=
er 'hpsa_sas_transport_functions'
drivers/scsi/hpsa.c:9648:20: error: 'hpsa_sas_get_linkerrors' undeclare=
d (first use in this function)
drivers/scsi/hpsa.c:9649:30: error: 'hpsa_sas_get_enclosure_identifier'=
 undeclared (first use in this function)
drivers/scsi/hpsa.c:9650:24: error: 'hpsa_sas_get_bay_identifier' undec=
lared (first use in this function)
drivers/scsi/hpsa.c:9651:15: error: 'hpsa_sas_phy_reset' undeclared (fi=
rst use in this function)
drivers/scsi/hpsa.c:9652:16: error: 'hpsa_sas_phy_enable' undeclared (f=
irst use in this function)
drivers/scsi/hpsa.c:9653:15: error: 'hpsa_sas_phy_setup' undeclared (fi=
rst use in this function)
drivers/scsi/hpsa.c:9654:17: error: 'hpsa_sas_phy_release' undeclared (=
first use in this function)
drivers/scsi/hpsa.c:9655:19: error: 'hpsa_sas_phy_speed' undeclared (fi=
rst use in this function)
drivers/scsi/hpsa.c:9656:17: error: 'hpsa_sas_smp_handler' undeclared (=
first use in this function)
drivers/scsi/hpsa.c:9764:13: error: 'hpsa_init' undeclared (first use i=
n this function)
drivers/scsi/hpsa.c:9764:1: error: 'hpsa_init' undeclared (first use in=
 this function)
drivers/scsi/hpsa.c:9764:1: error: parameter '__initcall_hpsa_init6' is=
 initialized
drivers/scsi/hpsa.c:9764:1: note: in expansion of macro 'module_init'
drivers/scsi/hpsa.c:9764:1: warning: '__used__' attribute ignored [-Wat=
tributes]
drivers/scsi/hpsa.c:9765:13: error: 'hpsa_cleanup' undeclared (first us=
e in this function)
drivers/scsi/hpsa.c:9765:1: error: 'hpsa_cleanup' undeclared (first use=
 in this function)
drivers/scsi/hpsa.c:9765:1: error: parameter '__exitcall_hpsa_cleanup' =
is initialized
drivers/scsi/hpsa.c:9765:1: note: in expansion of macro 'module_exit'
drivers/scsi/hpsa.c:9765:26: error: expected '{' at end of input
drivers/scsi/hpsa.h:586:29: warning: 'SA5_ioaccel_mode1_access' defined=
 but not used [-Wunused-variable]
drivers/scsi/hpsa.h:593:29: warning: 'SA5_ioaccel_mode2_access' defined=
 but not used [-Wunused-variable]
drivers/scsi/hpsa.h:600:29: warning: 'SA5_performant_access' defined bu=
t not used [-Wunused-variable]
drivers/scsi/hpsa.h:607:29: warning: 'SA5_performant_access_no_read' de=
fined but not used [-Wunused-variable]
include/linux/compiler.h:147:2: error: expected declaration specifiers =
before 'if'
include/linux/compiler.h:161:3: error: expected declaration specifiers =
before ')' token
include/linux/init.h:183:20: error: section attribute not allowed for '=
__initcall_hpsa_init6'
include/linux/init.h:183:20: error: storage class specified for paramet=
er '__initcall_hpsa_init6'
include/linux/init.h:219:24: note: in expansion of macro 'device_initca=
ll'
include/linux/init.h:222:20: error: section attribute not allowed for '=
__exitcall_hpsa_cleanup'
include/linux/init.h:222:20: error: storage class specified for paramet=
er '__exitcall_hpsa_cleanup'
include/linux/module.h:129:2: error: expected '=3D', ',', ';', 'asm' or=
 '__attribute__' before '{' token
include/linux/module.h:129:2: warning: 'alias' attribute ignored [-Watt=
ributes]
include/linux/module.h:84:24: note: in expansion of macro '__initcall'
include/linux/module.h:84:37: error: expected declaration specifiers be=
fore ';' token
include/linux/module.h:96:24: note: in expansion of macro '__exitcall'

Error ids grouped by kconfigs:

recent_errors
=E2=94=9C=E2=94=80=E2=94=80 alpha-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 arch-alpha-include-as=
m-string.h:error:expected-declaration-specifiers-before-__builtin_memcp=
y
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 i386-allmodconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 arch-x86-include-asm-=
string_32.h:error:expected-declaration-specifiers-before-__builtin_memc=
py
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:warning:alias-attribute-ignored
=E2=94=9C=E2=94=80=E2=94=80 i386-randconfig-x005-201551
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 arch-x86-include-asm-=
string_32.h:error:expected-declaration-specifiers-before-__builtin_memc=
py
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-compile=
r.h:error:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-compile=
r.h:error:expected-declaration-specifiers-before-)-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:warning:alias-attribute-ignored
=E2=94=9C=E2=94=80=E2=94=80 ia64-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 parisc-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 powerpc-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 s390-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 sparc64-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 arch-sparc-include-as=
m-string_64.h:error:expected-declaration-specifiers-before-__builtin_me=
mcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 sparc-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 tile-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=9C=E2=94=80=E2=94=80 x86_64-acpi-redef
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 x86_64-allmodconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:warning:alias-attribute-ignored
=E2=94=9C=E2=94=80=E2=94=80 x86_64-allyesconfig
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 x86_64-allyesdebian
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 x86_64-randconfig-x017-201551
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_cleanup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-__exitcall_hpsa_cleanup-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_init6-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:__used__-attribute-ignored
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:section-attribute-not-allowed-for-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-__exitcall_hpsa_cleanup
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
error:storage-class-specified-for-parameter-hpsa_init6
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:=
note:in-expansion-of-macro-device_initcall
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__exitcall
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:note:in-expansion-of-macro-__initcall
=E2=94=9C=E2=94=80=E2=94=80 x86_64-rhel
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-at-end-of-input
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bmic_device_index
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-bssbp
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-c
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-ei
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-else
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-encl_dev
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-id_phys
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-if
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-kfree
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-memcpy
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-out
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-rc
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:expected-declaration-specifiers-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_init_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_remove_one-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_resume-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_bay_identifier-undeclared-(first-use-in-this-function=
)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_enclosure_identifier-undeclared-(first-use-in-this-fu=
nction)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_get_linkerrors-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_enable-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_release-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_reset-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_setup-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_phy_speed-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_sas_smp_handler-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_shutdown-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:hpsa_suspend-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:old-style-parameter-declarations-in-prototyped-function-definition
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bmic_device_index-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-bssbp-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-c-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-ei-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_pci_driver-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-hpsa_sas_transport_functions-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-id_phys-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rc-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:parameter-rle-is-initialized
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rle_index-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:rlep-undeclared-(first-use-in-this-function)
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_pci_driver
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:e=
rror:storage-class-specified-for-parameter-hpsa_sas_transport_functions
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_exit
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:n=
ote:in-expansion-of-macro-module_init
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_alloc-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:cmd_tagged_free-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:fill_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:finish_cmd-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_add_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_change_queue_depth-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_command_resubmit_worker-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_compat_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_driver_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_abort_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_eh_device_reset_handler-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_find_device_by_sas_rphy-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_ioctl-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_remove_sas_device-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_sas_transport_template-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_finished-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scan_start-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:hpsa_scsi_queue_command-used-but-never-defined
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:number_of_controllers-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:w=
arning:products-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode1_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_ioaccel_mode2_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.h:w=
arning:SA5_performant_access_no_read-defined-but-not-used
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.=
h:error:expected-asm-or-__attribute__-before-token
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 include-linux-module.=
h:warning:alias-attribute-ignored
=E2=94=94=E2=94=80=E2=94=80 xtensa-allyesconfig
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-asm-=
or-__attribute__-before-token
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-at-e=
nd-of-input
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-bmic_device_index
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-bssbp
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-c
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-ei
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-else
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-encl_dev
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-id_phys
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-if
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-kfree
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-memcpy
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-out
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-rc
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:expected-decl=
aration-specifiers-before-token
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_cleanup-=
undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_init_one=
-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_init-und=
eclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_remove_o=
ne-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_resume-u=
ndeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_get_=
bay_identifier-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_get_=
enclosure_identifier-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_get_=
linkerrors-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_phy_=
enable-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_phy_=
release-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_phy_=
reset-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_phy_=
setup-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_phy_=
speed-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_sas_smp_=
handler-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_shutdown=
-undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:hpsa_suspend-=
undeclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:old-style-par=
ameter-declarations-in-prototyped-function-definition
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-bmi=
c_device_index-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-bss=
bp-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-c-i=
s-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-ei-=
is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-__e=
xitcall_hpsa_cleanup-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-hps=
a_init6-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-hps=
a_pci_driver-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-hps=
a_sas_transport_functions-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-id_=
phys-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-rc-=
is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:parameter-rle=
-is-initialized
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:rle_index-und=
eclared-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:rlep-undeclar=
ed-(first-use-in-this-function)
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:storage-class=
-specified-for-parameter-hpsa_pci_driver
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:error:storage-class=
-specified-for-parameter-hpsa_sas_transport_functions
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:note:in-expansion-o=
f-macro-module_exit
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:note:in-expansion-o=
f-macro-module_init
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:cmd_alloc-u=
sed-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:cmd_free-us=
ed-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:cmd_tagged_=
free-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:fill_cmd-us=
ed-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:finish_cmd-=
used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_add_sa=
s_device-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_change=
_queue_depth-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_comman=
d_resubmit_worker-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_eh_abo=
rt_handler-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_eh_dev=
ice_reset_handler-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_find_d=
evice_by_sas_rphy-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_ioctl-=
used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_remove=
_sas_device-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_scan_f=
inished-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_scan_s=
tart-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:hpsa_scsi_q=
ueue_command-used-but-never-defined
    =E2=94=9C=E2=94=80=E2=94=80 drivers-scsi-hpsa.c:warning:__used__-at=
tribute-ignored
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:error:section-attr=
ibute-not-allowed-for-__exitcall_hpsa_cleanup
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:error:section-attr=
ibute-not-allowed-for-hpsa_init6
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:error:storage-clas=
s-specified-for-parameter-__exitcall_hpsa_cleanup
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:error:storage-clas=
s-specified-for-parameter-hpsa_init6
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-init.h:note:in-expansion-=
of-macro-device_initcall
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.h:error:expected-d=
eclaration-specifiers-before-token
    =E2=94=9C=E2=94=80=E2=94=80 include-linux-module.h:note:in-expansio=
n-of-macro-__exitcall
    =E2=94=94=E2=94=80=E2=94=80 include-linux-module.h:note:in-expansio=
n-of-macro-__initcall

elapsed time: 45m

configs tested: 106

i386                     randconfig-a0-201551
x86_64                                nfsroot
i386                               tinyconfig
alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
x86_64                 randconfig-x015-201551
x86_64                 randconfig-x019-201551
x86_64                 randconfig-x010-201551
x86_64                 randconfig-x016-201551
x86_64                 randconfig-x012-201551
x86_64                 randconfig-x011-201551
x86_64                 randconfig-x013-201551
x86_64                 randconfig-x017-201551
x86_64                 randconfig-x014-201551
x86_64                 randconfig-x018-201551
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
i386                     randconfig-s0-201551
i386                     randconfig-s1-201551
x86_64                 randconfig-s3-12220135
x86_64                 randconfig-s4-12220135
x86_64                 randconfig-s5-12220135
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
x86_64                   randconfig-i0-201551
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
i386                     randconfig-i0-201551
i386                     randconfig-i1-201551
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
x86_64                                    lkp
i386                     randconfig-n0-201551
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
arm                               allnoconfig
arm                         at91_dt_defconfig
arm                                  at_hdmac
arm                                    ep93xx
arm                       imx_v6_v7_defconfig
arm                                  iop-adma
arm                          marzen_defconfig
arm                          prima2_defconfig
arm                                    sa1100
arm                                   samsung
arm                                        sh
arm                       spear13xx_defconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
x86_64                 randconfig-x006-201551
x86_64                 randconfig-x009-201551
x86_64                 randconfig-x003-201551
x86_64                 randconfig-x008-201551
x86_64                 randconfig-x005-201551
x86_64                 randconfig-x001-201551
x86_64                 randconfig-x002-201551
x86_64                 randconfig-x000-201551
x86_64                 randconfig-x004-201551
x86_64                 randconfig-x007-201551
i386                     randconfig-r0-201551
i386                   randconfig-x008-201551
i386                   randconfig-x009-201551
i386                   randconfig-x003-201551
i386                   randconfig-x006-201551
i386                   randconfig-x001-201551
i386                   randconfig-x002-201551
i386                   randconfig-x000-201551
i386                   randconfig-x004-201551
i386                   randconfig-x007-201551
i386                   randconfig-x005-201551
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                                     txx9

Thanks,
=46engguang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

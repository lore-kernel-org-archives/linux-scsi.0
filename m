From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 3/4] scsi: scsi_dh_alua: do not print RTPG state if it
 remains unavailable/standby
Date: Tue, 11 Jul 2017 22:11:43 +0800
Message-ID: <201707112121.bRdlbO7o%fengguang.wu@intel.com>
References: <1499726857-7875-4-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499726857-7875-4-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: kbuild-all@01.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hare@suse.de, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Mauricio,

[auto build test WARNING on bvanassche/for-next]
[also build test WARNING on v4.12 next-20170711]
[cannot apply to mkp-scsi/for-next scsi/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauricio-Faria-de-Oliveira/scsi_dh_alua-fix-stuck-I-O-after-unavailable-standby-states/20170711-141350
base:   https://github.com/bvanassche/linux for-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/device_handler/scsi_dh_alua.c:594:9-10: WARNING: return of 0/1 in function 'alua_rtpg_print_check' with return type bool

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

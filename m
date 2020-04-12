Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACC8C2BA2B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47559206DA
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgDLH46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 03:56:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:63081 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgDLH45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Apr 2020 03:56:57 -0400
IronPort-SDR: j7e3dy9pLqvu/skfqNQjGUdbGw26CyrdFM4cZEe6mmC7yZtq2sZrUPLTMtuoDNge5Q53s83jug
 hsIuFZ1+5LkQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 00:56:55 -0700
IronPort-SDR: qssAA8qSYrF2I4znTYfIdtDFt6nT5/lUdn/0x4oKqk8PgNa2Cv/ZQ7iDXu241YQQBgKHBNYeeT
 6wdu98opl5uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,374,1580803200"; 
   d="scan'208";a="241376347"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 12 Apr 2020 00:56:51 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jNXU2-0009i3-VU; Sun, 12 Apr 2020 15:56:50 +0800
Date:   Sun, 12 Apr 2020 15:56:04 +0800
From:   kbuild test robot <lkp@intel.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 31/31] elx: efct: Tie into kernel Kconfig and build
 process
Message-ID: <202004121536.BAc7Prmw%lkp@intel.com>
References: <20200412033303.29574-32-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412033303.29574-32-jsmart2021@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on scsi/for-next linus/master v5.6 next-20200412]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/James-Smart/efct-Broadcom-Emulex-FC-Target-driver/20200412-114125
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)

>> drivers/scsi/elx/efct/efct_driver.c:829:5: warning: Redundant initialization for 'rc'. The initialized value is overwritten before it is read. [redundantInitialization]
    rc = efct_device_init();
       ^
   drivers/scsi/elx/efct/efct_driver.c:827:9: note: rc is initialized
    int rc = -ENODEV;
           ^
   drivers/scsi/elx/efct/efct_driver.c:829:5: note: rc is overwritten
    rc = efct_device_init();
       ^
   drivers/scsi/elx/efct/efct_driver.c:255:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc = 0, i;
        ^
   drivers/scsi/elx/efct/efct_driver.c:255:14: warning: The scope of the variable 'i' can be reduced. [variableScope]
    int rc = 0, i;
                ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
>> drivers/scsi/elx/efct/efct_driver.c:255:9: warning: Variable 'rc' is assigned a value that is never used. [unreadVariable]
    int rc = 0, i;
           ^
--
>> drivers/scsi/elx/efct/efct_scsi.c:869:34: warning: Either the condition '!fcprsp' is redundant or there is pointer arithmetic with NULL pointer. [nullPointerArithmeticRedundantCheck]
     u8 *sns_data = io->rspbuf.virt + sizeof(*fcprsp);
                                    ^
   drivers/scsi/elx/efct/efct_scsi.c:871:7: note: Assuming that condition '!fcprsp' is not redundant
     if (!fcprsp) {
         ^
   drivers/scsi/elx/efct/efct_scsi.c:868:48: note: Assignment from 'io->rspbuf.virt'
     struct fcp_resp_with_ext *fcprsp = io->rspbuf.virt;
                                                  ^
   drivers/scsi/elx/efct/efct_scsi.c:869:34: note: Null pointer addition
     u8 *sns_data = io->rspbuf.virt + sizeof(*fcprsp);
                                    ^
   drivers/scsi/elx/efct/efct_scsi.c:467:21: warning: The scope of the variable 'hio' can be reduced. [variableScope]
    struct efct_hw_io *hio;
                       ^
   drivers/scsi/elx/efct/efct_scsi.c:470:6: warning: The scope of the variable 'dispatch' can be reduced. [variableScope]
    int dispatch;
        ^
>> drivers/scsi/elx/efct/efct_scsi.c:869:34: warning: 'io->rspbuf.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
     u8 *sns_data = io->rspbuf.virt + sizeof(*fcprsp);
                                    ^
   drivers/scsi/elx/efct/efct_scsi.c:1045:28: warning: 'io->rspbuf.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    rspinfo = io->rspbuf.virt + sizeof(*fcprsp);
                              ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
>> drivers/scsi/elx/efct/efct_scsi.c:482:10: warning: Variable 'status' is assigned a value that is never used. [unreadVariable]
     status = 0;
            ^
--
   drivers/scsi/elx/efct/efct_els.c:1767:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc;
        ^
>> drivers/scsi/elx/efct/efct_els.c:980:32: warning: 'els->els_req.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    rscn_page = els->els_req.virt + sizeof(*req);
                                  ^
   drivers/scsi/elx/efct/efct_els.c:1471:28: warning: 'els->els_req.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    rftid = els->els_req.virt + sizeof(*ct);
                              ^
   drivers/scsi/elx/efct/efct_els.c:1515:28: warning: 'els->els_req.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    rffid = els->els_req.virt + sizeof(*ct);
                              ^
   drivers/scsi/elx/efct/efct_els.c:1567:28: warning: 'els->els_req.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    gidpt = els->els_req.virt + sizeof(*ct);
                              ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
>> drivers/scsi/elx/efct/efct_els.c:1600:8: warning: Variable 's_id' is assigned a value that is never used. [unreadVariable]
     s_id = U32_MAX;
          ^
--
>> drivers/scsi/elx/efct/efct_xport.c:341:6: warning: Variable 'rc' is reassigned a value before the old one has been used. [redundantAssignment]
     rc = efct_hw_get_host_stats(&efct->hw, 1,
        ^
   drivers/scsi/elx/efct/efct_xport.c:329:6: note: rc is assigned
     rc = efct_hw_get_link_stats(&efct->hw, 0, 1, 1,
        ^
   drivers/scsi/elx/efct/efct_xport.c:341:6: note: rc is overwritten
     rc = efct_hw_get_host_stats(&efct->hw, 1,
        ^
   drivers/scsi/elx/efct/efct_xport.c:619:17: warning: The scope of the variable 'timeout' can be reduced. [variableScope]
     unsigned long timeout;
                   ^
   drivers/scsi/elx/efct/efct_xport.c:836:23: warning: The scope of the variable 'sport' can be reduced. [variableScope]
    struct efc_sli_port *sport;
                         ^
   drivers/scsi/elx/efct/efct_xport.c:884:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc;
        ^
>> drivers/scsi/elx/efct/efct_xport.c:678:16: warning: Local variable 'efct' shadows outer variable [shadowVariable]
     struct efct *efct;
                  ^
   drivers/scsi/elx/efct/efct_xport.c:590:15: note: Shadowed declaration
    struct efct *efct = NULL;
                 ^
   drivers/scsi/elx/efct/efct_xport.c:678:16: note: Shadow variable
     struct efct *efct;
                  ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
--
   drivers/scsi/elx/efct/efct_hw.c:871:16: warning: The scope of the variable 'rq' can be reduced. [variableScope]
    struct hw_rq *rq;
                  ^
   drivers/scsi/elx/efct/efct_hw.c:1224:16: warning: The scope of the variable 'rq' can be reduced. [variableScope]
    struct hw_rq *rq;
                  ^
   drivers/scsi/elx/efct/efct_hw.c:1325:16: warning: The scope of the variable 'rq' can be reduced. [variableScope]
    struct hw_rq *rq;
                  ^
   drivers/scsi/elx/efct/efct_hw.c:2367:7: warning: The scope of the variable 'status' can be reduced. [variableScope]
    int  status;
         ^
>> drivers/scsi/elx/efct/efct_hw.c:480:9: warning: Local variable 'arg' shadows outer argument [shadowArgument]
     void *arg = io->arg;
           ^
   drivers/scsi/elx/efct/efct_hw.c:383:29: note: Shadowed declaration
   efct_hw_wq_process_io(void *arg, u8 *cqe, int status)
                               ^
   drivers/scsi/elx/efct/efct_hw.c:480:9: note: Shadow variable
     void *arg = io->arg;
           ^
   drivers/scsi/elx/efct/efct_hw.c:1862:9: warning: Local variable 'arg' shadows outer argument [shadowArgument]
     void *arg = io->arg;
           ^
   drivers/scsi/elx/efct/efct_hw.c:1842:32: note: Shadowed declaration
   efct_hw_wq_process_abort(void *arg, u8 *cqe, int status)
                                  ^
   drivers/scsi/elx/efct/efct_hw.c:1862:9: note: Shadow variable
     void *arg = io->arg;
           ^
   drivers/scsi/elx/efct/efct_hw.c:1881:9: warning: Local variable 'arg' shadows outer argument [shadowArgument]
     void *arg = io->abort_arg;
           ^
   drivers/scsi/elx/efct/efct_hw.c:1842:32: note: Shadowed declaration
   efct_hw_wq_process_abort(void *arg, u8 *cqe, int status)
                                  ^
   drivers/scsi/elx/efct/efct_hw.c:1881:9: note: Shadow variable
     void *arg = io->abort_arg;
           ^
>> drivers/scsi/elx/efct/efct_hw.c:1300:23: warning: 'hw->seq_pool' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
      seq = hw->seq_pool + idx * sizeof(*seq);
                         ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
>> drivers/scsi/elx/efct/efct_hw.c:633:8: warning: Variable 'i' is assigned a value that is never used. [unreadVariable]
    u32 i = 0, io_index = 0;
          ^
   drivers/scsi/elx/efct/efct_hw.c:2056:8: warning: Variable 'i' is assigned a value that is never used. [unreadVariable]
    u32 i = 0;
          ^
--
   drivers/scsi/elx/libefc/efc_domain.c:392:23: warning: The scope of the variable 'sport' can be reduced. [variableScope]
    struct efc_sli_port *sport;
                         ^
   drivers/scsi/elx/libefc/efc_domain.c:499:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc = 0;
        ^
   drivers/scsi/elx/libefc/efc_domain.c:546:7: warning: The scope of the variable 'rc' can be reduced. [variableScope]
     int rc;
         ^
   drivers/scsi/elx/libefc/efc_domain.c:699:7: warning: The scope of the variable 'rc' can be reduced. [variableScope]
     int rc;
         ^
   drivers/scsi/elx/libefc/efc_domain.c:866:7: warning: The scope of the variable 'rc' can be reduced. [variableScope]
     int rc;
         ^
>> drivers/scsi/elx/libefc/efc_domain.c:546:7: warning: Local variable 'rc' shadows outer variable [shadowVariable]
     int rc;
         ^
   drivers/scsi/elx/libefc/efc_domain.c:499:6: note: Shadowed declaration
    int rc = 0;
        ^
   drivers/scsi/elx/libefc/efc_domain.c:546:7: note: Shadow variable
     int rc;
         ^
--
>> drivers/scsi/elx/libefc/efc_fabric.c:1274:14: warning: Variable 'remote_wwpn' is reassigned a value before the old one has been used. [redundantAssignment]
    remote_wwpn = efc_get_wwpn(remote_sp);
                ^
   drivers/scsi/elx/libefc/efc_fabric.c:1270:14: note: remote_wwpn is assigned
    remote_wwpn = efc_get_wwpn(remote_sp);
                ^
   drivers/scsi/elx/libefc/efc_fabric.c:1274:14: note: remote_wwpn is overwritten
    remote_wwpn = efc_get_wwpn(remote_sp);
                ^
   drivers/scsi/elx/libefc/efc_fabric.c:26:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc;
        ^
   drivers/scsi/elx/libefc/efc_fabric.c:479:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc;
        ^
   drivers/scsi/elx/libefc/efc_fabric.c:1502:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc;
        ^
>> drivers/scsi/elx/libefc/efc_fabric.c:726:38: warning: 'data' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    struct fc_gid_pn_resp *gidpt = data + sizeof(*hdr);
                                        ^
--
>> drivers/scsi/elx/efct/efct_lio.c:1663:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_TPG_ATTRIB(generate_node_acls);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1664:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_TPG_ATTRIB(cache_dynamic_acls);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1665:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_TPG_ATTRIB(demo_mode_write_protect);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1666:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_TPG_ATTRIB(prod_mode_write_protect);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1667:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_TPG_ATTRIB(demo_mode_login_only);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1719:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_NPIV_TPG_ATTRIB(generate_node_acls);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1720:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_NPIV_TPG_ATTRIB(cache_dynamic_acls);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1721:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_NPIV_TPG_ATTRIB(demo_mode_write_protect);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1722:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_NPIV_TPG_ATTRIB(prod_mode_write_protect);
   ^
   drivers/scsi/elx/efct/efct_lio.c:1723:1: warning: %u in format string (no. 1) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   DEF_EFCT_NPIV_TPG_ATTRIB(demo_mode_login_only);
   ^
   drivers/scsi/elx/efct/efct_lio.c:93:6: warning: The scope of the variable 'ret' can be reduced. [variableScope]
    int ret;
        ^
   drivers/scsi/elx/efct/efct_lio.c:150:6: warning: The scope of the variable 'ret' can be reduced. [variableScope]
    int ret;
        ^
>> drivers/scsi/elx/efct/efct_lio.c:480:22: warning: Passing NULL after the last typed argument to a variadic function leads to undefined behaviour. [varFuncNullUB]
     EFCT_XPORT_SHUTDOWN, NULL);
                        ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
>> drivers/scsi/elx/efct/efct_lio.c:461:2: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_CMPL_CMD);
    ^
--
>> drivers/scsi/elx/libefc/efc_node.c:887:2: warning: %llX in format string (no. 1) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    snprintf(buffer, buffer_len, "eui.%016llX", eui_name);
    ^
--
   drivers/scsi/elx/efct/efct_unsol.c:28:16: warning: The scope of the variable 'flags' can be reduced. [variableScope]
    unsigned long flags = 0;
                  ^
   drivers/scsi/elx/efct/efct_unsol.c:210:26: warning: The scope of the variable 'frame' can be reduced. [variableScope]
    struct efc_hw_sequence *frame;
                            ^
   drivers/scsi/elx/efct/efct_unsol.c:533:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc = 0;
        ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^
>> drivers/scsi/elx/efct/efct_unsol.c:533:9: warning: Variable 'rc' is assigned a value that is never used. [unreadVariable]
    int rc = 0;
           ^
--
>> drivers/scsi/elx/libefc/efc_sport.c:101:2: warning: %llX in format string (no. 1) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    snprintf(sport->wwnn_str, sizeof(sport->wwnn_str), "%016llX", wwnn);
    ^
   drivers/scsi/elx/libefc/efc_sport.c:422:20: warning: The scope of the variable 'fabric' can be reduced. [variableScope]
     struct efc_node *fabric;
                      ^
--
   drivers/scsi/elx/libefc/efc_device.c:485:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc;
        ^
   drivers/scsi/elx/libefc/efc_device.c:1486:6: warning: The scope of the variable 'rc' can be reduced. [variableScope]
    int rc = EFC_SCSI_CALL_COMPLETE;
        ^
   drivers/scsi/elx/libefc/efc_device.c:1487:6: warning: The scope of the variable 'rc_2' can be reduced. [variableScope]
    int rc_2 = EFC_SCSI_CALL_COMPLETE;
        ^
>> drivers/scsi/elx/libefc/efc_device.c:372:31: warning: 'prli' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
    struct fc_els_spp *sp = prli + sizeof(struct fc_els_prli);
                                 ^
>> drivers/scsi/elx/libefc/efc_device.c:1193:6: warning: 'cbdata->payload->dma.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
        + sizeof(struct fc_els_prli);
        ^
   drivers/scsi/elx/libefc/efc_device.c:1397:6: warning: 'cbdata->payload->dma.virt' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
        + sizeof(struct fc_els_prli);
        ^
--
>> drivers/scsi/elx/libefc_sli/sli4.c:1372:6: warning: Condition 'valid' is always true [knownConditionTrueFalse]
    if (valid && clear) {
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:1367:6: note: Assuming that condition '!valid' is not redundant
    if (!valid) {
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:1372:6: note: Condition 'valid' is always true
    if (valid && clear) {
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:1425:6: warning: Condition 'valid' is always true [knownConditionTrueFalse]
    if (valid && clear) {
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:1420:6: note: Assuming that condition '!valid' is not redundant
    if (!valid) {
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:1425:6: note: Condition 'valid' is always true
    if (valid && clear) {
        ^
>> drivers/scsi/elx/libefc_sli/sli4.c:4018:2: warning: Either the condition 'extent' is redundant or there is possible null pointer dereference: extent. [nullPointerRedundantCheck]
    extent->resource_type = cpu_to_le16(rtype);
    ^
   drivers/scsi/elx/libefc_sli/sli4.c:4011:6: note: Assuming that condition 'extent' is not redundant
    if (extent)
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:4018:2: note: Null pointer dereference
    extent->resource_type = cpu_to_le16(rtype);
    ^
   drivers/scsi/elx/libefc_sli/sli4.c:2175:19: warning: The scope of the variable 'bptr' can be reduced. [variableScope]
    struct sli4_bde *bptr;
                     ^
>> drivers/scsi/elx/libefc_sli/sli4.c:3068:35: warning: Local variable 'rcqe' shadows outer variable [shadowVariable]
     struct sli4_fc_coalescing_rcqe *rcqe = (void *)cqe;
                                     ^
   drivers/scsi/elx/libefc_sli/sli4.c:2995:29: note: Shadowed declaration
    struct sli4_fc_async_rcqe *rcqe = (void *)cqe;
                               ^
   drivers/scsi/elx/libefc_sli/sli4.c:3068:35: note: Shadow variable
     struct sli4_fc_coalescing_rcqe *rcqe = (void *)cqe;
                                     ^
>> drivers/scsi/elx/libefc_sli/sli4.c:3069:7: warning: Local variable 'rq_element_index' shadows outer variable [shadowVariable]
     u16 rq_element_index =
         ^
   drivers/scsi/elx/libefc_sli/sli4.c:2999:6: note: Shadowed declaration
    u16 rq_element_index;
        ^
   drivers/scsi/elx/libefc_sli/sli4.c:3069:7: note: Shadow variable
     u16 rq_element_index =
         ^
>> drivers/scsi/elx/libefc_sli/sli4.c:4487:8: warning: Local variable 'i' shadows outer variable [shadowVariable]
      u32 i = 0, size = 0;
          ^
   drivers/scsi/elx/libefc_sli/sli4.c:4470:7: note: Shadowed declaration
     u32 i;
         ^
   drivers/scsi/elx/libefc_sli/sli4.c:4487:8: note: Shadow variable
      u32 i = 0, size = 0;
          ^
>> drivers/scsi/elx/libefc_sli/sli4.c:71:7: warning: 'buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
     buf += offsetof(struct sli4_cmd_sli_config, payload.embed);
         ^
>> drivers/scsi/elx/libefc_sli/sli4.h:96:26: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_CTRL_FDD = (1 << 31),
                            ^
   drivers/scsi/elx/libefc_sli/sli4.h:223:29: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_PORT_STATUS_ERR  = (1 << 31),
                               ^
   drivers/scsi/elx/libefc_sli/sli4.h:315:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SGE_LAST   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:418:24: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_MCQE_VALID  = (1 << 31),
                          ^
   drivers/scsi/elx/libefc_sli/sli4.h:682:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_EQESZ   = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:685:23: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_EQ_ARM   = (1 << 31),
                         ^
   drivers/scsi/elx/libefc_sli/sli4.h:729:25: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    CREATE_MQEXT_VAL  = (1 << 31),
                           ^
   drivers/scsi/elx/libefc_sli/sli4.h:2665:30: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_READ_LNKSTAT_CLOF = (1 << 31),
                                ^
   drivers/scsi/elx/libefc_sli/sli4.h:3473:35: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
    SLI4_SET_RECONFIG_LINKID_FD = (1 << 31),
                                     ^

vim +/rc +829 drivers/scsi/elx/efct/efct_driver.c

3569c2ab8265ff James Smart 2020-04-11  823  
3569c2ab8265ff James Smart 2020-04-11  824  static
3569c2ab8265ff James Smart 2020-04-11  825  int __init efct_init(void)
3569c2ab8265ff James Smart 2020-04-11  826  {
3569c2ab8265ff James Smart 2020-04-11  827  	int	rc = -ENODEV;
3569c2ab8265ff James Smart 2020-04-11  828  
3569c2ab8265ff James Smart 2020-04-11 @829  	rc = efct_device_init();
3569c2ab8265ff James Smart 2020-04-11  830  	if (rc) {
3569c2ab8265ff James Smart 2020-04-11  831  		pr_err("efct_device_init failed rc=%d\n", rc);
3569c2ab8265ff James Smart 2020-04-11  832  		return -ENOMEM;
3569c2ab8265ff James Smart 2020-04-11  833  	}
3569c2ab8265ff James Smart 2020-04-11  834  
3569c2ab8265ff James Smart 2020-04-11  835  	rc = pci_register_driver(&efct_pci_driver);
3569c2ab8265ff James Smart 2020-04-11  836  	if (rc)
3569c2ab8265ff James Smart 2020-04-11  837  		goto l1;
3569c2ab8265ff James Smart 2020-04-11  838  
3569c2ab8265ff James Smart 2020-04-11  839  	return rc;
3569c2ab8265ff James Smart 2020-04-11  840  
3569c2ab8265ff James Smart 2020-04-11  841  l1:
3569c2ab8265ff James Smart 2020-04-11  842  	efct_device_shutdown();
3569c2ab8265ff James Smart 2020-04-11  843  	return rc;
3569c2ab8265ff James Smart 2020-04-11  844  }
3569c2ab8265ff James Smart 2020-04-11  845  

:::::: The code at line 829 was first introduced by commit
:::::: 3569c2ab8265ffc43780ee31f4c4ef80e37cf0f7 elx: efct: Driver initialization routines

:::::: TO: James Smart <jsmart2021@gmail.com>
:::::: CC: 0day robot <lkp@intel.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

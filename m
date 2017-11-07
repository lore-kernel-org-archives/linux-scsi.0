From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/4] qla2xxx_nvmet: Added Makefile and Kconfig changes
Date: Tue, 7 Nov 2017 16:24:12 +0800
Message-ID: <201711071622.VxHcz353%fengguang.wu@intel.com>
References: <20171106195530.17408-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55741 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933148AbdKGIYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Nov 2017 03:24:16 -0500
Content-Disposition: inline
In-Reply-To: <20171106195530.17408-3-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Anil,

I love your patch! Yet something to improve:

[auto build test ERROR on scsi/for-next]
[also build test ERROR on v4.14-rc8 next-20171106]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Add-FC-NVMe-Target-support/20171107-153645
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: i386-randconfig-x001-201745 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: the linux-review/Himanshu-Madhani/qla2xxx-Add-FC-NVMe-Target-support/20171107-153645 HEAD 9c5e24e821aa40552221b3103bc914bc4cd42293 builds fine.
      It only hurts bisectibility.

All error/warnings (new ones prefixed by >>):

   In file included from drivers/scsi/qla2xxx/qla_nvmet.c:14:0:
   drivers/scsi/qla2xxx/qla_nvmet.h:31:25: error: field 'nvme_cmd_iu' has incomplete type
     struct atio7_nvme_cmnd nvme_cmd_iu;
                            ^~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qlt_nvmet_ls_done':
>> drivers/scsi/qla2xxx/qla_nvmet.c:48:46: error: 'struct <anonymous>' has no member named 'cmd'
     struct qla_nvmet_cmd *tgt_cmd = nvme->u.nvme.cmd;
                                                 ^
   drivers/scsi/qla2xxx/qla_nvmet.c:55:47: error: 'struct <anonymous>' has no member named 'cmd'
      sp, sp->vha, nvme->u.nvme.desc, nvme->u.nvme.cmd);
                                                  ^
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_ls_rsp':
>> drivers/scsi/qla2xxx/qla_nvmet.c:92:13: error: 'SRB_NVMET_LS' undeclared (first use in this function)
     sp->type = SRB_NVMET_LS;
                ^~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c:92:13: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/scsi/qla2xxx/qla_nvmet.c:100:14: error: 'struct <anonymous>' has no member named 'exchange_address'
     nvme->u.nvme.exchange_address = tgt_cmd->atio.u.pt_ls4.exchange_address;
                 ^
>> drivers/scsi/qla2xxx/qla_nvmet.c:100:49: error: 'union <anonymous>' has no member named 'pt_ls4'
     nvme->u.nvme.exchange_address = tgt_cmd->atio.u.pt_ls4.exchange_address;
                                                    ^
>> drivers/scsi/qla2xxx/qla_nvmet.c:101:14: error: 'struct <anonymous>' has no member named 'nport_handle'
     nvme->u.nvme.nport_handle = tgt_cmd->atio.u.pt_ls4.nport_handle;
                 ^
   drivers/scsi/qla2xxx/qla_nvmet.c:101:45: error: 'union <anonymous>' has no member named 'pt_ls4'
     nvme->u.nvme.nport_handle = tgt_cmd->atio.u.pt_ls4.nport_handle;
                                                ^
>> drivers/scsi/qla2xxx/qla_nvmet.c:102:14: error: 'struct <anonymous>' has no member named 'vp_index'
     nvme->u.nvme.vp_index = tgt_cmd->atio.u.pt_ls4.vp_index;
                 ^
   drivers/scsi/qla2xxx/qla_nvmet.c:102:41: error: 'union <anonymous>' has no member named 'pt_ls4'
     nvme->u.nvme.vp_index = tgt_cmd->atio.u.pt_ls4.vp_index;
                                            ^
   drivers/scsi/qla2xxx/qla_nvmet.c:104:14: error: 'struct <anonymous>' has no member named 'cmd'
     nvme->u.nvme.cmd = tgt_cmd; /* To be freed */
                 ^
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_fcp_abort':
>> drivers/scsi/qla2xxx/qla_nvmet.c:168:13: error: 'SRB_NVMET_SEND_ABTS' undeclared (first use in this function)
     sp->type = SRB_NVMET_SEND_ABTS;
                ^~~~~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_create_targetport':
>> drivers/scsi/qla2xxx/qla_nvmet.c:226:9: error: 'ql_dbg_nvme' undeclared (first use in this function)
     ql_dbg(ql_dbg_nvme, vha, 0xe081,
            ^~~~~~~~~~~
>> drivers/scsi/qla2xxx/qla_nvmet.c:236:10: error: 'struct scsi_qla_host' has no member named 'targetport'
         &vha->targetport);
             ^~
   drivers/scsi/qla2xxx/qla_nvmet.c:243:41: error: 'struct scsi_qla_host' has no member named 'targetport'
     tport = (struct qla_nvmet_tgtport *)vha->targetport->private;
                                            ^~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_delete':
>> drivers/scsi/qla2xxx/qla_nvmet.c:261:17: error: 'volatile struct <anonymous>' has no member named 'nvmet_enabled'; did you mean 'nvme_enabled'?
     if (!vha->flags.nvmet_enabled)
                    ^
   drivers/scsi/qla2xxx/qla_nvmet.c:263:9: error: 'struct scsi_qla_host' has no member named 'targetport'
     if (vha->targetport) {
            ^~
   drivers/scsi/qla2xxx/qla_nvmet.c:264:42: error: 'struct scsi_qla_host' has no member named 'targetport'
      tport = (struct qla_nvmet_tgtport *)vha->targetport->private;
                                             ^~
   drivers/scsi/qla2xxx/qla_nvmet.c:266:10: error: 'ql_dbg_nvme' undeclared (first use in this function)
      ql_dbg(ql_dbg_nvme, vha, 0xe083,
             ^~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c:269:37: error: 'struct scsi_qla_host' has no member named 'targetport'
      nvmet_fc_unregister_targetport(vha->targetport);
                                        ^~
>> drivers/scsi/qla2xxx/qla_nvmet.c:272:3: error: implicit declaration of function 'nvmet_release_sessions' [-Werror=implicit-function-declaration]
      nvmet_release_sessions(vha);
      ^~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_handle_ls':
>> drivers/scsi/qla2xxx/qla_nvmet.c:300:9: error: implicit declaration of function 'qla_nvmet_find_sess_by_s_id' [-Werror=implicit-function-declaration]
     sess = qla_nvmet_find_sess_by_s_id(vha, look_up_sid);
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/qla2xxx/qla_nvmet.c:300:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     sess = qla_nvmet_find_sess_by_s_id(vha, look_up_sid);
          ^
   drivers/scsi/qla2xxx/qla_nvmet.c:308:10: error: 'ql_dbg_nvme' undeclared (first use in this function)
      ql_dbg(ql_dbg_nvme, vha, 0xe084,
             ^~~~~~~~~~~
   In file included from arch/x86/include/asm/string.h:2:0,
                    from include/linux/string.h:18,
                    from include/linux/scatterlist.h:4,
                    from drivers/scsi/qla2xxx/qla_nvmet.c:8:
   drivers/scsi/qla2xxx/qla_nvmet.c:316:25: error: 'union <anonymous>' has no member named 'pt_ls4'
     memcpy(&tgt_cmd->atio.u.pt_ls4, pt_ls4, sizeof(struct pt_ls4_rx_unsol));
                            ^
   arch/x86/include/asm/string_32.h:184:42: note: in definition of macro 'memcpy'
    #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
                                             ^
   drivers/scsi/qla2xxx/qla_nvmet.c:327:31: error: 'struct scsi_qla_host' has no member named 'targetport'
     ret = nvmet_fc_rcv_ls_req(vha->targetport,
                                  ^~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_process_cmd':
   drivers/scsi/qla2xxx/qla_nvmet.c:360:32: error: 'struct scsi_qla_host' has no member named 'targetport'
     ret = nvmet_fc_rcv_fcp_req(vha->targetport, &tgt_cmd->cmd.fcp_req,
                                   ^~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_handle_abts':
   drivers/scsi/qla2xxx/qla_nvmet.c:400:28: error: 'struct scsi_qla_host' has no member named 'targetport'
     nvmet_fc_rcv_fcp_abort(vha->targetport, &cmd->cmd.fcp_req);
                               ^~
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_send_resp_ctio':
>> drivers/scsi/qla2xxx/qla_nvmet.c:456:34: error: 'union <anonymous>' has no member named 'nvme_isp27'
     struct fcp_hdr *fchdr = &atio->u.nvme_isp27.fcp_hdr;
                                     ^
>> drivers/scsi/qla2xxx/qla_nvmet.c:477:13: error: 'SRB_NVMET_FCP' undeclared (first use in this function)
     sp->type = SRB_NVMET_FCP;
                ^~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c:481:23: error: 'struct <anonymous>' has no member named 'cmd'
     sp->u.iocb_cmd.u.nvme.cmd = cmd;
                          ^
   drivers/scsi/qla2xxx/qla_nvmet.c:485:10: error: 'ql_dbg_nvme' undeclared (first use in this function)
      ql_dbg(ql_dbg_nvme, vha, 0x3067,
             ^~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c:501:31: error: 'union <anonymous>' has no member named 'nvme_isp27'
     ctio->exchange_addr = atio->u.nvme_isp27.exchange_addr;
                                  ^
   drivers/scsi/qla2xxx/qla_nvmet.c:505:19: error: 'union <anonymous>' has no member named 'nvme_isp27'
     c_flags = atio->u.nvme_isp27.attr << 9;
                      ^
   drivers/scsi/qla2xxx/qla_nvmet.c: In function 'qla_nvmet_send_abts_ctio':
>> drivers/scsi/qla2xxx/qla_nvmet.c:731:13: error: 'SRB_NVMET_ABTS' undeclared (first use in this function)
     sp->type = SRB_NVMET_ABTS;
                ^~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_nvmet.c:737:10: error: 'ql_dbg_nvme' undeclared (first use in this function)
      ql_dbg(ql_dbg_nvme, vha, 0x3067,
             ^~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +48 drivers/scsi/qla2xxx/qla_nvmet.c

3465c5ae Anil Gurumurthy 2017-11-06   12  
3465c5ae Anil Gurumurthy 2017-11-06   13  #include "qla_nvme.h"
3465c5ae Anil Gurumurthy 2017-11-06  @14  #include "qla_nvmet.h"
3465c5ae Anil Gurumurthy 2017-11-06   15  
3465c5ae Anil Gurumurthy 2017-11-06   16  #if	IS_ENABLED(CONFIG_NVME_TARGET_FC)
3465c5ae Anil Gurumurthy 2017-11-06   17  static void qla_nvmet_send_resp_ctio(struct qla_qpair *qpair,
3465c5ae Anil Gurumurthy 2017-11-06   18  	struct qla_nvmet_cmd *cmd, struct nvmefc_tgt_fcp_req *rsp);
3465c5ae Anil Gurumurthy 2017-11-06   19  static void qla_nvmet_send_abts_ctio(struct scsi_qla_host *vha,
3465c5ae Anil Gurumurthy 2017-11-06   20  		struct abts_recv_from_24xx *abts, bool flag);
3465c5ae Anil Gurumurthy 2017-11-06   21  
3465c5ae Anil Gurumurthy 2017-11-06   22  /*
3465c5ae Anil Gurumurthy 2017-11-06   23   * qla_nvmet_targetport_delete -
3465c5ae Anil Gurumurthy 2017-11-06   24   * Invoked by the nvmet to indicate that the target port has
3465c5ae Anil Gurumurthy 2017-11-06   25   * been deleted
3465c5ae Anil Gurumurthy 2017-11-06   26   */
3465c5ae Anil Gurumurthy 2017-11-06   27  static void
3465c5ae Anil Gurumurthy 2017-11-06   28  qla_nvmet_targetport_delete(struct nvmet_fc_target_port *targetport)
3465c5ae Anil Gurumurthy 2017-11-06   29  {
3465c5ae Anil Gurumurthy 2017-11-06   30  	struct qla_nvmet_tgtport *tport = targetport->private;
3465c5ae Anil Gurumurthy 2017-11-06   31  
3465c5ae Anil Gurumurthy 2017-11-06   32  	complete(&tport->tport_del);
3465c5ae Anil Gurumurthy 2017-11-06   33  }
3465c5ae Anil Gurumurthy 2017-11-06   34  #endif
3465c5ae Anil Gurumurthy 2017-11-06   35  
3465c5ae Anil Gurumurthy 2017-11-06   36  #if	IS_ENABLED(CONFIG_NVME_TARGET_FC)
3465c5ae Anil Gurumurthy 2017-11-06   37  /*
3465c5ae Anil Gurumurthy 2017-11-06   38   * qlt_nvmet_ls_done -
3465c5ae Anil Gurumurthy 2017-11-06   39   * Invoked by the firmware interface to indicate the completion
3465c5ae Anil Gurumurthy 2017-11-06   40   * of an LS cmd
3465c5ae Anil Gurumurthy 2017-11-06   41   * Free all associated resources of the LS cmd
3465c5ae Anil Gurumurthy 2017-11-06   42   */
3465c5ae Anil Gurumurthy 2017-11-06   43  static void qlt_nvmet_ls_done(void *ptr, int res)
3465c5ae Anil Gurumurthy 2017-11-06   44  {
3465c5ae Anil Gurumurthy 2017-11-06   45  	struct srb *sp = ptr;
3465c5ae Anil Gurumurthy 2017-11-06   46  	struct srb_iocb   *nvme = &sp->u.iocb_cmd;
3465c5ae Anil Gurumurthy 2017-11-06   47  	struct nvmefc_tgt_ls_req *rsp = nvme->u.nvme.desc;
3465c5ae Anil Gurumurthy 2017-11-06  @48  	struct qla_nvmet_cmd *tgt_cmd = nvme->u.nvme.cmd;
3465c5ae Anil Gurumurthy 2017-11-06   49  
3465c5ae Anil Gurumurthy 2017-11-06   50  	ql_log(ql_log_info, sp->vha, 0x11000,
3465c5ae Anil Gurumurthy 2017-11-06   51  		"Done with NVME LS4 req\n");
3465c5ae Anil Gurumurthy 2017-11-06   52  
3465c5ae Anil Gurumurthy 2017-11-06   53  	ql_log(ql_log_info, sp->vha, 0x11001,
3465c5ae Anil Gurumurthy 2017-11-06   54  		"sp: %p vha: %p, rsp: %p, cmd: %p\n",
3465c5ae Anil Gurumurthy 2017-11-06  @55  		sp, sp->vha, nvme->u.nvme.desc, nvme->u.nvme.cmd);
3465c5ae Anil Gurumurthy 2017-11-06   56  
3465c5ae Anil Gurumurthy 2017-11-06   57  	rsp->done(rsp);
3465c5ae Anil Gurumurthy 2017-11-06   58  	/* Free tgt_cmd */
3465c5ae Anil Gurumurthy 2017-11-06   59  	kfree(tgt_cmd->buf);
3465c5ae Anil Gurumurthy 2017-11-06   60  	kfree(tgt_cmd);
3465c5ae Anil Gurumurthy 2017-11-06   61  	qla2x00_rel_sp(sp);
3465c5ae Anil Gurumurthy 2017-11-06   62  }
3465c5ae Anil Gurumurthy 2017-11-06   63  
3465c5ae Anil Gurumurthy 2017-11-06   64  /*
3465c5ae Anil Gurumurthy 2017-11-06   65   * qla_nvmet_ls_rsp -
3465c5ae Anil Gurumurthy 2017-11-06   66   * Invoked by the nvme-t to complete the LS req.
3465c5ae Anil Gurumurthy 2017-11-06   67   * Prepare and send a response CTIO to the firmware.
3465c5ae Anil Gurumurthy 2017-11-06   68   */
3465c5ae Anil Gurumurthy 2017-11-06   69  static int
3465c5ae Anil Gurumurthy 2017-11-06   70  qla_nvmet_ls_rsp(struct nvmet_fc_target_port *tgtport,
3465c5ae Anil Gurumurthy 2017-11-06   71  			struct nvmefc_tgt_ls_req *rsp)
3465c5ae Anil Gurumurthy 2017-11-06   72  {
3465c5ae Anil Gurumurthy 2017-11-06   73  	struct qla_nvmet_cmd *tgt_cmd =
3465c5ae Anil Gurumurthy 2017-11-06   74  		container_of(rsp, struct qla_nvmet_cmd, cmd.ls_req);
3465c5ae Anil Gurumurthy 2017-11-06   75  	struct scsi_qla_host *vha = tgt_cmd->vha;
3465c5ae Anil Gurumurthy 2017-11-06   76  	struct srb_iocb   *nvme;
3465c5ae Anil Gurumurthy 2017-11-06   77  	int     rval = QLA_FUNCTION_FAILED;
3465c5ae Anil Gurumurthy 2017-11-06   78  	srb_t *sp;
3465c5ae Anil Gurumurthy 2017-11-06   79  
3465c5ae Anil Gurumurthy 2017-11-06   80  	ql_log(ql_log_info, vha, 0x11002,
3465c5ae Anil Gurumurthy 2017-11-06   81  		"Dumping the NVMET-LS response buffer\n");
3465c5ae Anil Gurumurthy 2017-11-06   82  	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
3465c5ae Anil Gurumurthy 2017-11-06   83  		(uint8_t *)rsp->rspbuf, rsp->rsplen);
3465c5ae Anil Gurumurthy 2017-11-06   84  
3465c5ae Anil Gurumurthy 2017-11-06   85  	/* Alloc SRB structure */
3465c5ae Anil Gurumurthy 2017-11-06   86  	sp = qla2x00_get_sp(vha, NULL, GFP_ATOMIC);
3465c5ae Anil Gurumurthy 2017-11-06   87  	if (!sp) {
3465c5ae Anil Gurumurthy 2017-11-06   88  		ql_log(ql_log_info, vha, 0x11003, "Failed to allocate SRB\n");
3465c5ae Anil Gurumurthy 2017-11-06   89  		return -ENOMEM;
3465c5ae Anil Gurumurthy 2017-11-06   90  	}
3465c5ae Anil Gurumurthy 2017-11-06   91  
3465c5ae Anil Gurumurthy 2017-11-06  @92  	sp->type = SRB_NVMET_LS;
3465c5ae Anil Gurumurthy 2017-11-06   93  	sp->done = qlt_nvmet_ls_done;
3465c5ae Anil Gurumurthy 2017-11-06   94  	sp->vha = vha;
3465c5ae Anil Gurumurthy 2017-11-06   95  	sp->fcport = tgt_cmd->fcport;
3465c5ae Anil Gurumurthy 2017-11-06   96  
3465c5ae Anil Gurumurthy 2017-11-06   97  	nvme = &sp->u.iocb_cmd;
3465c5ae Anil Gurumurthy 2017-11-06   98  	nvme->u.nvme.rsp_dma = rsp->rspdma;
3465c5ae Anil Gurumurthy 2017-11-06   99  	nvme->u.nvme.rsp_len = rsp->rsplen;
3465c5ae Anil Gurumurthy 2017-11-06 @100  	nvme->u.nvme.exchange_address = tgt_cmd->atio.u.pt_ls4.exchange_address;
3465c5ae Anil Gurumurthy 2017-11-06 @101  	nvme->u.nvme.nport_handle = tgt_cmd->atio.u.pt_ls4.nport_handle;
3465c5ae Anil Gurumurthy 2017-11-06 @102  	nvme->u.nvme.vp_index = tgt_cmd->atio.u.pt_ls4.vp_index;
3465c5ae Anil Gurumurthy 2017-11-06  103  
3465c5ae Anil Gurumurthy 2017-11-06 @104  	nvme->u.nvme.cmd = tgt_cmd; /* To be freed */
3465c5ae Anil Gurumurthy 2017-11-06  105  	nvme->u.nvme.desc = rsp; /* Call back to nvmet */
3465c5ae Anil Gurumurthy 2017-11-06  106  
3465c5ae Anil Gurumurthy 2017-11-06  107  	rval = qla2x00_start_sp(sp);
3465c5ae Anil Gurumurthy 2017-11-06  108  	if (rval != QLA_SUCCESS) {
3465c5ae Anil Gurumurthy 2017-11-06  109  		ql_log(ql_log_warn, vha, 0x11004,
3465c5ae Anil Gurumurthy 2017-11-06  110  			"qla2x00_start_sp failed = %d\n", rval);
3465c5ae Anil Gurumurthy 2017-11-06  111  		return rval;
3465c5ae Anil Gurumurthy 2017-11-06  112  	}
3465c5ae Anil Gurumurthy 2017-11-06  113  
3465c5ae Anil Gurumurthy 2017-11-06  114  	return 0;
3465c5ae Anil Gurumurthy 2017-11-06  115  }
3465c5ae Anil Gurumurthy 2017-11-06  116  
3465c5ae Anil Gurumurthy 2017-11-06  117  /*
3465c5ae Anil Gurumurthy 2017-11-06  118   * qla_nvmet_fcp_op -
3465c5ae Anil Gurumurthy 2017-11-06  119   * Invoked by the nvme-t to complete the IO.
3465c5ae Anil Gurumurthy 2017-11-06  120   * Prepare and send a response CTIO to the firmware.
3465c5ae Anil Gurumurthy 2017-11-06  121   */
3465c5ae Anil Gurumurthy 2017-11-06  122  static int
3465c5ae Anil Gurumurthy 2017-11-06  123  qla_nvmet_fcp_op(struct nvmet_fc_target_port *tgtport,
3465c5ae Anil Gurumurthy 2017-11-06  124  			struct nvmefc_tgt_fcp_req *rsp)
3465c5ae Anil Gurumurthy 2017-11-06  125  {
3465c5ae Anil Gurumurthy 2017-11-06  126  	struct qla_nvmet_cmd *tgt_cmd =
3465c5ae Anil Gurumurthy 2017-11-06  127  		container_of(rsp, struct qla_nvmet_cmd, cmd.fcp_req);
3465c5ae Anil Gurumurthy 2017-11-06  128  	struct scsi_qla_host *vha = tgt_cmd->vha;
3465c5ae Anil Gurumurthy 2017-11-06  129  
3465c5ae Anil Gurumurthy 2017-11-06  130  	/* Prepare and send CTIO 82h */
3465c5ae Anil Gurumurthy 2017-11-06  131  	qla_nvmet_send_resp_ctio(vha->qpair, tgt_cmd, rsp);
3465c5ae Anil Gurumurthy 2017-11-06  132  
3465c5ae Anil Gurumurthy 2017-11-06  133  	return 0;
3465c5ae Anil Gurumurthy 2017-11-06  134  }
3465c5ae Anil Gurumurthy 2017-11-06  135  /*
3465c5ae Anil Gurumurthy 2017-11-06  136   * qla_nvmet_fcp_abort_done
3465c5ae Anil Gurumurthy 2017-11-06  137   * free up the used resources
3465c5ae Anil Gurumurthy 2017-11-06  138   */
3465c5ae Anil Gurumurthy 2017-11-06  139  static void qla_nvmet_fcp_abort_done(void *ptr, int res)
3465c5ae Anil Gurumurthy 2017-11-06  140  {
3465c5ae Anil Gurumurthy 2017-11-06  141  	srb_t *sp = ptr;
3465c5ae Anil Gurumurthy 2017-11-06  142  
3465c5ae Anil Gurumurthy 2017-11-06  143  	qla2x00_rel_sp(sp);
3465c5ae Anil Gurumurthy 2017-11-06  144  }
3465c5ae Anil Gurumurthy 2017-11-06  145  
3465c5ae Anil Gurumurthy 2017-11-06  146  /*
3465c5ae Anil Gurumurthy 2017-11-06  147   * qla_nvmet_fcp_abort -
3465c5ae Anil Gurumurthy 2017-11-06  148   * Invoked by the nvme-t to abort an IO
3465c5ae Anil Gurumurthy 2017-11-06  149   * Send an abort to the firmware
3465c5ae Anil Gurumurthy 2017-11-06  150   */
3465c5ae Anil Gurumurthy 2017-11-06  151  static void
3465c5ae Anil Gurumurthy 2017-11-06  152  qla_nvmet_fcp_abort(struct nvmet_fc_target_port *tgtport,
3465c5ae Anil Gurumurthy 2017-11-06  153  			struct nvmefc_tgt_fcp_req *req)
3465c5ae Anil Gurumurthy 2017-11-06  154  {
3465c5ae Anil Gurumurthy 2017-11-06  155  	struct qla_nvmet_cmd *tgt_cmd =
3465c5ae Anil Gurumurthy 2017-11-06  156  		container_of(req, struct qla_nvmet_cmd, cmd.fcp_req);
3465c5ae Anil Gurumurthy 2017-11-06  157  	struct scsi_qla_host *vha = tgt_cmd->vha;
3465c5ae Anil Gurumurthy 2017-11-06  158  	struct qla_hw_data *ha = vha->hw;
3465c5ae Anil Gurumurthy 2017-11-06  159  	srb_t *sp;
3465c5ae Anil Gurumurthy 2017-11-06  160  
3465c5ae Anil Gurumurthy 2017-11-06  161  	/* Alloc SRB structure */
3465c5ae Anil Gurumurthy 2017-11-06  162  	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
3465c5ae Anil Gurumurthy 2017-11-06  163  	if (!sp) {
3465c5ae Anil Gurumurthy 2017-11-06  164  		ql_log(ql_log_info, vha, 0x11005, "Failed to allocate SRB\n");
3465c5ae Anil Gurumurthy 2017-11-06  165  		return;
3465c5ae Anil Gurumurthy 2017-11-06  166  	}
3465c5ae Anil Gurumurthy 2017-11-06  167  
3465c5ae Anil Gurumurthy 2017-11-06 @168  	sp->type = SRB_NVMET_SEND_ABTS;
3465c5ae Anil Gurumurthy 2017-11-06  169  	sp->done = qla_nvmet_fcp_abort_done;
3465c5ae Anil Gurumurthy 2017-11-06  170  	sp->vha = vha;
3465c5ae Anil Gurumurthy 2017-11-06  171  	sp->fcport = tgt_cmd->fcport;
3465c5ae Anil Gurumurthy 2017-11-06  172  
3465c5ae Anil Gurumurthy 2017-11-06  173  	ha->isp_ops->abort_command(sp);
3465c5ae Anil Gurumurthy 2017-11-06  174  
3465c5ae Anil Gurumurthy 2017-11-06  175  }
3465c5ae Anil Gurumurthy 2017-11-06  176  
3465c5ae Anil Gurumurthy 2017-11-06  177  /*
3465c5ae Anil Gurumurthy 2017-11-06  178   * qla_nvmet_fcp_req_release -
3465c5ae Anil Gurumurthy 2017-11-06  179   * Delete the cmd from the list and free the cmd
3465c5ae Anil Gurumurthy 2017-11-06  180   */
3465c5ae Anil Gurumurthy 2017-11-06  181  
3465c5ae Anil Gurumurthy 2017-11-06  182  static void
3465c5ae Anil Gurumurthy 2017-11-06  183  qla_nvmet_fcp_req_release(struct nvmet_fc_target_port *tgtport,
3465c5ae Anil Gurumurthy 2017-11-06  184  			struct nvmefc_tgt_fcp_req *rsp)
3465c5ae Anil Gurumurthy 2017-11-06  185  {
3465c5ae Anil Gurumurthy 2017-11-06  186  	struct qla_nvmet_cmd *tgt_cmd =
3465c5ae Anil Gurumurthy 2017-11-06  187  		container_of(rsp, struct qla_nvmet_cmd, cmd.fcp_req);
3465c5ae Anil Gurumurthy 2017-11-06  188  	scsi_qla_host_t *vha = tgt_cmd->vha;
3465c5ae Anil Gurumurthy 2017-11-06  189  	unsigned long flags;
3465c5ae Anil Gurumurthy 2017-11-06  190  
3465c5ae Anil Gurumurthy 2017-11-06  191  	spin_lock_irqsave(&vha->cmd_list_lock, flags);
3465c5ae Anil Gurumurthy 2017-11-06  192  	list_del(&tgt_cmd->cmd_list);
3465c5ae Anil Gurumurthy 2017-11-06  193  	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
3465c5ae Anil Gurumurthy 2017-11-06  194  
3465c5ae Anil Gurumurthy 2017-11-06  195  	kfree(tgt_cmd);
3465c5ae Anil Gurumurthy 2017-11-06  196  }
3465c5ae Anil Gurumurthy 2017-11-06  197  
3465c5ae Anil Gurumurthy 2017-11-06  198  static struct nvmet_fc_target_template qla_nvmet_fc_transport = {
3465c5ae Anil Gurumurthy 2017-11-06  199  	.targetport_delete	= qla_nvmet_targetport_delete,
3465c5ae Anil Gurumurthy 2017-11-06  200  	.xmt_ls_rsp		= qla_nvmet_ls_rsp,
3465c5ae Anil Gurumurthy 2017-11-06  201  	.fcp_op			= qla_nvmet_fcp_op,
3465c5ae Anil Gurumurthy 2017-11-06  202  	.fcp_abort		= qla_nvmet_fcp_abort,
3465c5ae Anil Gurumurthy 2017-11-06  203  	.fcp_req_release	= qla_nvmet_fcp_req_release,
3465c5ae Anil Gurumurthy 2017-11-06  204  	.max_hw_queues		= 8,
3465c5ae Anil Gurumurthy 2017-11-06  205  	.max_sgl_segments	= 128,
3465c5ae Anil Gurumurthy 2017-11-06  206  	.max_dif_sgl_segments	= 64,
3465c5ae Anil Gurumurthy 2017-11-06  207  	.dma_boundary		= 0xFFFFFFFF,
3465c5ae Anil Gurumurthy 2017-11-06  208  	.target_features	= NVMET_FCTGTFEAT_READDATA_RSP |
3465c5ae Anil Gurumurthy 2017-11-06  209  					NVMET_FCTGTFEAT_CMD_IN_ISR |
3465c5ae Anil Gurumurthy 2017-11-06  210  					NVMET_FCTGTFEAT_OPDONE_IN_ISR,
3465c5ae Anil Gurumurthy 2017-11-06  211  	.target_priv_sz	= sizeof(struct nvme_private),
3465c5ae Anil Gurumurthy 2017-11-06  212  };
3465c5ae Anil Gurumurthy 2017-11-06  213  #endif
3465c5ae Anil Gurumurthy 2017-11-06  214  /*
3465c5ae Anil Gurumurthy 2017-11-06  215   * qla_nvmet_create_targetport -
3465c5ae Anil Gurumurthy 2017-11-06  216   * Create a targetport. Registers the template with the nvme-t
3465c5ae Anil Gurumurthy 2017-11-06  217   * layer
3465c5ae Anil Gurumurthy 2017-11-06  218   */
3465c5ae Anil Gurumurthy 2017-11-06  219  int qla_nvmet_create_targetport(struct scsi_qla_host *vha)
3465c5ae Anil Gurumurthy 2017-11-06  220  {
3465c5ae Anil Gurumurthy 2017-11-06  221  #if	IS_ENABLED(CONFIG_NVME_TARGET_FC)
3465c5ae Anil Gurumurthy 2017-11-06  222  	struct nvmet_fc_port_info pinfo;
3465c5ae Anil Gurumurthy 2017-11-06  223  	struct qla_nvmet_tgtport *tport;
3465c5ae Anil Gurumurthy 2017-11-06  224  	int error = 0;
3465c5ae Anil Gurumurthy 2017-11-06  225  
3465c5ae Anil Gurumurthy 2017-11-06 @226  	ql_dbg(ql_dbg_nvme, vha, 0xe081,
3465c5ae Anil Gurumurthy 2017-11-06  227  		"Creating target port for :%p\n", vha);
3465c5ae Anil Gurumurthy 2017-11-06  228  
3465c5ae Anil Gurumurthy 2017-11-06  229  	memset(&pinfo, 0, (sizeof(struct nvmet_fc_port_info)));
3465c5ae Anil Gurumurthy 2017-11-06  230  	pinfo.node_name = wwn_to_u64(vha->node_name);
3465c5ae Anil Gurumurthy 2017-11-06  231  	pinfo.port_name = wwn_to_u64(vha->port_name);
3465c5ae Anil Gurumurthy 2017-11-06  232  	pinfo.port_id	= vha->d_id.b24;
3465c5ae Anil Gurumurthy 2017-11-06  233  
3465c5ae Anil Gurumurthy 2017-11-06  234  	error = nvmet_fc_register_targetport(&pinfo,
3465c5ae Anil Gurumurthy 2017-11-06  235  	    &qla_nvmet_fc_transport, &vha->hw->pdev->dev,
3465c5ae Anil Gurumurthy 2017-11-06 @236  	    &vha->targetport);
3465c5ae Anil Gurumurthy 2017-11-06  237  
3465c5ae Anil Gurumurthy 2017-11-06  238  	if (error) {
3465c5ae Anil Gurumurthy 2017-11-06  239  		ql_dbg(ql_dbg_nvme, vha, 0xe082,
3465c5ae Anil Gurumurthy 2017-11-06  240  			"Cannot register NVME transport:%d\n", error);
3465c5ae Anil Gurumurthy 2017-11-06  241  		return error;
3465c5ae Anil Gurumurthy 2017-11-06  242  	}
3465c5ae Anil Gurumurthy 2017-11-06  243  	tport = (struct qla_nvmet_tgtport *)vha->targetport->private;
3465c5ae Anil Gurumurthy 2017-11-06  244  	tport->vha = vha;
3465c5ae Anil Gurumurthy 2017-11-06  245  	ql_dbg(ql_dbg_nvme, vha, 0xe082,
3465c5ae Anil Gurumurthy 2017-11-06  246  		" Registered NVME transport:%p WWPN:%llx\n",
3465c5ae Anil Gurumurthy 2017-11-06  247  		tport, pinfo.port_name);
3465c5ae Anil Gurumurthy 2017-11-06  248  #endif
3465c5ae Anil Gurumurthy 2017-11-06  249  	return 0;
3465c5ae Anil Gurumurthy 2017-11-06  250  }
3465c5ae Anil Gurumurthy 2017-11-06  251  

:::::: The code at line 48 was first introduced by commit
:::::: 3465c5aeb3161f2f168841ded707571ffe38d136 qla2xxx_nvmet: Add files for FC-NVMe Target support

:::::: TO: Anil Gurumurthy <anil.gurumurthy@cavium.com>
:::::: CC: 0day robot <fengguang.wu@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--MGYHOYXEY6WxJCY8
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
Dcz/AYM6sN6fEAIA

--MGYHOYXEY6WxJCY8--

Return-Path: <SRS0=GkA7=ZP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E02C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Nov 2019 05:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A44B2071C
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Nov 2019 05:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfKWF6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Nov 2019 00:58:14 -0500
Received: from mga14.intel.com ([192.55.52.115]:55471 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfKWF6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Nov 2019 00:58:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 21:58:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,232,1571727600"; 
   d="scan'208";a="210475027"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2019 21:58:09 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYOQr-0000iD-Ae; Sat, 23 Nov 2019 13:58:09 +0800
Date:   Sat, 23 Nov 2019 13:57:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: Re: [PATCH v2 15/15] scsi: qla2xxx: Handle ABTS according to FCP
 spec for logged out ports
Message-ID: <201911231335.1Zob6cyP%lkp@intel.com>
References: <20191120222723.27779-16-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120222723.27779-16-r.bolshakov@yadro.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Roman,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20191122]
[cannot apply to v5.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Roman-Bolshakov/scsi-qla2xxx-Bug-fixes/20191122-011503
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-36-g9305d48-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/qla2xxx/qla_target.c:5780:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5791:21: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:5795:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5840:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5850:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5866:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5867:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5870:29: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:5874:37: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1689:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1691:25: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:1700:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] srr_flags @@    got resunsigned short [usertype] srr_flags @@
   drivers/scsi/qla2xxx/qla_target.c:1700:33: sparse:    expected unsigned short [usertype] srr_flags
   drivers/scsi/qla2xxx/qla_target.c:1700:33: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2136:13: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:2158:13: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:837:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:845:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1177:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1318:36: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1760:15: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] f_ctl @@    got restrunsigned int [usertype] f_ctl @@
   drivers/scsi/qla2xxx/qla_target.c:1760:15: sparse:    expected unsigned int [usertype] f_ctl
   drivers/scsi/qla2xxx/qla_target.c:1760:15: sparse:    got restricted __le32 [usertype]
>> drivers/scsi/qla2xxx/qla_target.c:1829:37: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] control_flags @@    got resunsigned short [usertype] control_flags @@
>> drivers/scsi/qla2xxx/qla_target.c:1829:37: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_target.c:1829:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1836:15: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] f_ctl @@    got restrunsigned int [usertype] f_ctl @@
   drivers/scsi/qla2xxx/qla_target.c:1836:15: sparse:    expected unsigned int [usertype] f_ctl
   drivers/scsi/qla2xxx/qla_target.c:1836:15: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1909:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] timeout @@    got resunsigned short [usertype] timeout @@
   drivers/scsi/qla2xxx/qla_target.c:1909:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:1909:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1928:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] ox_id @@    got tricted __le16 [usertype] ox_id @@
   drivers/scsi/qla2xxx/qla_target.c:1928:31: sparse:    expected restricted __le16 [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:1928:31: sparse:    got unsigned short [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:2230:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] timeout @@    got resunsigned short [usertype] timeout @@
   drivers/scsi/qla2xxx/qla_target.c:2230:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2230:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2239:37: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] scsi_status @@    got resunsigned short [usertype] scsi_status @@
   drivers/scsi/qla2xxx/qla_target.c:2239:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2239:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2241:38: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] response_len @@    got resunsigned short [usertype] response_len @@
   drivers/scsi/qla2xxx/qla_target.c:2241:38: sparse:    expected unsigned short [usertype] response_len
   drivers/scsi/qla2xxx/qla_target.c:2241:38: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2287:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] timeout @@    got resunsigned short [usertype] timeout @@
   drivers/scsi/qla2xxx/qla_target.c:2287:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2287:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2296:37: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] scsi_status @@    got resunsigned short [usertype] scsi_status @@
   drivers/scsi/qla2xxx/qla_target.c:2296:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2296:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2298:38: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] response_len @@    got resunsigned short [usertype] response_len @@
   drivers/scsi/qla2xxx/qla_target.c:2298:38: sparse:    expected unsigned short [usertype] response_len
   drivers/scsi/qla2xxx/qla_target.c:2298:38: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:2299:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] residual @@    got restrunsigned int [usertype] residual @@
   drivers/scsi/qla2xxx/qla_target.c:2299:34: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:2299:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2302:45: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:2302:45: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:2302:45: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:2588:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_target.c:2588:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:2588:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2589:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] timeout @@    got resunsigned short [usertype] timeout @@
   drivers/scsi/qla2xxx/qla_target.c:2589:22: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2589:22: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2596:40: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] relative_offset @@    got restrunsigned int [usertype] relative_offset @@
   drivers/scsi/qla2xxx/qla_target.c:2596:40: sparse:    expected unsigned int [usertype] relative_offset
   drivers/scsi/qla2xxx/qla_target.c:2596:40: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2651:42: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] transfer_length @@    got restrunsigned int [usertype] transfer_length @@
   drivers/scsi/qla2xxx/qla_target.c:2651:42: sparse:    expected unsigned int [usertype] transfer_length
   drivers/scsi/qla2xxx/qla_target.c:2651:42: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2658:35: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] dseg_count @@    got resunsigned short [usertype] dseg_count @@
   drivers/scsi/qla2xxx/qla_target.c:2658:35: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_target.c:2658:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2820:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] residual @@    got restrunsigned int [usertype] residual @@
   drivers/scsi/qla2xxx/qla_target.c:2820:34: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:2820:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2821:37: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] scsi_status @@    got resunsigned short [usertype] scsi_status @@
   drivers/scsi/qla2xxx/qla_target.c:2821:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2821:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2842:45: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:2842:45: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:2842:45: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:2844:46: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] sense_length @@    got resunsigned short [usertype] sense_length @@
   drivers/scsi/qla2xxx/qla_target.c:2844:46: sparse:    expected unsigned short [usertype] sense_length
   drivers/scsi/qla2xxx/qla_target.c:2844:46: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2847:69: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] @@    got restrunsigned int [usertype] @@
   drivers/scsi/qla2xxx/qla_target.c:2847:69: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2847:69: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3101:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_target.c:3101:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:3101:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3283:60: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] scsi_status @@    got resunsigned short [usertype] scsi_status @@
   drivers/scsi/qla2xxx/qla_target.c:3283:60: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:3283:60: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3285:57: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] residual @@    got restrunsigned int [usertype] residual @@
   drivers/scsi/qla2xxx/qla_target.c:3285:57: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:3285:57: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3101:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_target.c:3101:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:3101:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3461:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3461:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3461:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3461:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3462:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3462:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3462:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3462:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3463:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3463:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3463:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3463:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3463:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3463:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3465:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3465:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3465:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3465:26: sparse: sparse: cast to restricted __be16

vim +1829 drivers/scsi/qla2xxx/qla_target.c

  1797	
  1798	/*
  1799	 * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  1800	 */
  1801	static void qlt_24xx_send_abts_resp(struct qla_qpair *qpair,
  1802		struct abts_recv_from_24xx *abts, uint32_t status,
  1803		bool ids_reversed, bool term_exchange)
  1804	{
  1805		struct scsi_qla_host *vha = qpair->vha;
  1806		struct qla_hw_data *ha = vha->hw;
  1807		struct abts_resp_to_24xx *resp;
  1808		uint32_t f_ctl;
  1809		uint8_t *p;
  1810	
  1811		ql_dbg(ql_dbg_tgt, vha, 0xe006,
  1812		    "Sending task mgmt ABTS response (ha=%p, atio=%p, status=%x\n",
  1813		    ha, abts, status);
  1814	
  1815		resp = (struct abts_resp_to_24xx *)qla2x00_alloc_iocbs_ready(qpair,
  1816		    NULL);
  1817		if (!resp) {
  1818			ql_dbg(ql_dbg_tgt, vha, 0xe04a,
  1819			    "qla_target(%d): %s failed: unable to allocate "
  1820			    "request packet", vha->vp_idx, __func__);
  1821			return;
  1822		}
  1823	
  1824		resp->entry_type = ABTS_RESP_24XX;
  1825		resp->handle = QLA_TGT_SKIP_HANDLE;
  1826		resp->entry_count = 1;
  1827		resp->nport_handle = abts->nport_handle;
  1828		if (term_exchange)
> 1829			resp->control_flags = cpu_to_le16(ABTS_CONTR_FLG_TERM_EXCHG);
  1830		else
  1831			resp->control_flags = 0;
  1832		resp->vp_index = vha->vp_idx;
  1833		resp->sof_type = abts->sof_type;
  1834		resp->exchange_address = abts->exchange_address;
  1835		resp->fcp_hdr_le = abts->fcp_hdr_le;
  1836		f_ctl = cpu_to_le32(F_CTL_EXCH_CONTEXT_RESP |
  1837		    F_CTL_LAST_SEQ | F_CTL_END_SEQ |
  1838		    F_CTL_SEQ_INITIATIVE);
  1839		p = (uint8_t *)&f_ctl;
  1840		resp->fcp_hdr_le.f_ctl[0] = *p++;
  1841		resp->fcp_hdr_le.f_ctl[1] = *p++;
  1842		resp->fcp_hdr_le.f_ctl[2] = *p;
  1843		if (ids_reversed) {
  1844			resp->fcp_hdr_le.d_id = abts->fcp_hdr_le.d_id;
  1845			resp->fcp_hdr_le.s_id = abts->fcp_hdr_le.s_id;
  1846		} else {
  1847			resp->fcp_hdr_le.d_id = abts->fcp_hdr_le.s_id;
  1848			resp->fcp_hdr_le.s_id = abts->fcp_hdr_le.d_id;
  1849		}
  1850		resp->exchange_addr_to_abort = abts->exchange_addr_to_abort;
  1851		if (status == FCP_TMF_CMPL) {
  1852			resp->fcp_hdr_le.r_ctl = R_CTL_BASIC_LINK_SERV | R_CTL_B_ACC;
  1853			resp->payload.ba_acct.seq_id_valid = SEQ_ID_INVALID;
  1854			resp->payload.ba_acct.low_seq_cnt = 0x0000;
  1855			resp->payload.ba_acct.high_seq_cnt = 0xFFFF;
  1856			resp->payload.ba_acct.ox_id = abts->fcp_hdr_le.ox_id;
  1857			resp->payload.ba_acct.rx_id = abts->fcp_hdr_le.rx_id;
  1858		} else {
  1859			resp->fcp_hdr_le.r_ctl = R_CTL_BASIC_LINK_SERV | R_CTL_B_RJT;
  1860			resp->payload.ba_rjt.reason_code =
  1861				BA_RJT_REASON_CODE_UNABLE_TO_PERFORM;
  1862			/* Other bytes are zero */
  1863		}
  1864	
  1865		vha->vha_tgt.qla_tgt->abts_resp_expected++;
  1866	
  1867		/* Memory Barrier */
  1868		wmb();
  1869		if (qpair->reqq_start_iocbs)
  1870			qpair->reqq_start_iocbs(qpair);
  1871		else
  1872			qla2x00_start_iocbs(vha, qpair->req);
  1873	}
  1874	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

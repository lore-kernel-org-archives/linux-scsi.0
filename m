Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE40FC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 23:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 764F82074A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 23:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgC0XtR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 19:49:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:55864 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgC0XtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 19:49:17 -0400
IronPort-SDR: WX4czncgbcwAg4Eb9ZOYfHGeVVU3ggfH2e+7iC3nTg2sQ96Qa4pLs5r01IElN9ittK3b0AtEA5
 C2oa3Iieg6gQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 16:49:11 -0700
IronPort-SDR: jx0Z6avK/7QlDfahpI/6aZRGhG1VS9P5cI2e+kojqN55K9oF3nPVXcDqauFWIZuALRzqxBneTq
 0Hc1/oyq0+eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,314,1580803200"; 
   d="gz'50?scan'50,208,50";a="394532689"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Mar 2020 16:49:08 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jHyip-000I8g-Um; Sat, 28 Mar 2020 07:49:07 +0800
Date:   Sat, 28 Mar 2020 07:48:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 1/3] qla2xxx: Fix MPI failure AEN (8200) handling.
Message-ID: <202003280740.QVNSZvV9%lkp@intel.com>
References: <20200327143248.27288-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20200327143248.27288-2-njavali@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Nilesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on mkp-scsi/for-next next-20200327]
[cannot apply to v5.6-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Nilesh-Javali/qla2xxx-Updates-for-the-driver/20200328-041450
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: powerpc-defconfig (attached as .config)
compiler: powerpc64-linux-gcc (GCC) 9.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=9.2.0 make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/scsi/qla2xxx/qla_isr.c: In function 'qla2x00_async_event':
>> drivers/scsi/qla2xxx/qla_isr.c:903:5: warning: this 'else' clause does not guard... [-Wmisleading-indentation]
     903 |   } else
         |     ^~~~
   drivers/scsi/qla2xxx/qla_isr.c:908:4: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'else'
     908 |    if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
         |    ^~

vim +/else +903 drivers/scsi/qla2xxx/qla_isr.c

ff3a920efcdbfa Arun Easi           2020-03-27   792  
^1da177e4c3f41 Linus Torvalds      2005-04-16   793  /**
^1da177e4c3f41 Linus Torvalds      2005-04-16   794   * qla2x00_async_event() - Process aynchronous events.
2db6228d9cd13b Bart Van Assche     2018-01-23   795   * @vha: SCSI driver HA context
2db6228d9cd13b Bart Van Assche     2018-01-23   796   * @rsp: response queue
9a853f71804d80 Andrew Vasquez      2005-07-06   797   * @mb: Mailbox registers (0 - 3)
^1da177e4c3f41 Linus Torvalds      2005-04-16   798   */
2c3dfe3f6ad8da Seokmann Ju         2007-07-05   799  void
73208dfd7ab19f Anirban Chakraborty 2008-12-09   800  qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
^1da177e4c3f41 Linus Torvalds      2005-04-16   801  {
^1da177e4c3f41 Linus Torvalds      2005-04-16   802  	uint16_t	handle_cnt;
bdab23da71c369 Andrew Vasquez      2009-10-13   803  	uint16_t	cnt, mbx;
^1da177e4c3f41 Linus Torvalds      2005-04-16   804  	uint32_t	handles[5];
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   805  	struct qla_hw_data *ha = vha->hw;
3d71644cf952fd Andrew Vasquez      2005-07-06   806  	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
bdab23da71c369 Andrew Vasquez      2009-10-13   807  	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
bc5c2aad17b045 Andrew Vasquez      2010-12-21   808  	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
52c82823cc686d Bart Van Assche     2015-07-09   809  	uint32_t	rscn_entry, host_pid;
4d4df1932b6b11 Harihara Kadayam    2008-04-03   810  	unsigned long	flags;
ef86cb2059a14b Chad Dupuis         2014-09-25   811  	fc_port_t	*fcport = NULL;
^1da177e4c3f41 Linus Torvalds      2005-04-16   812  
45235022da9925 Quinn Tran          2018-07-18   813  	if (!vha->hw->flags.fw_started)
45235022da9925 Quinn Tran          2018-07-18   814  		return;
45235022da9925 Quinn Tran          2018-07-18   815  
^1da177e4c3f41 Linus Torvalds      2005-04-16   816  	/* Setup to process RIO completion. */
^1da177e4c3f41 Linus Torvalds      2005-04-16   817  	handle_cnt = 0;
6246b8a1d26c7c Giridhar Malavali   2012-02-09   818  	if (IS_CNA_CAPABLE(ha))
3a03eb797ce76a Andrew Vasquez      2009-01-05   819  		goto skip_rio;
^1da177e4c3f41 Linus Torvalds      2005-04-16   820  	switch (mb[0]) {
^1da177e4c3f41 Linus Torvalds      2005-04-16   821  	case MBA_SCSI_COMPLETION:
9a853f71804d80 Andrew Vasquez      2005-07-06   822  		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
^1da177e4c3f41 Linus Torvalds      2005-04-16   823  		handle_cnt = 1;
^1da177e4c3f41 Linus Torvalds      2005-04-16   824  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   825  	case MBA_CMPLT_1_16BIT:
9a853f71804d80 Andrew Vasquez      2005-07-06   826  		handles[0] = mb[1];
^1da177e4c3f41 Linus Torvalds      2005-04-16   827  		handle_cnt = 1;
^1da177e4c3f41 Linus Torvalds      2005-04-16   828  		mb[0] = MBA_SCSI_COMPLETION;
^1da177e4c3f41 Linus Torvalds      2005-04-16   829  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   830  	case MBA_CMPLT_2_16BIT:
9a853f71804d80 Andrew Vasquez      2005-07-06   831  		handles[0] = mb[1];
9a853f71804d80 Andrew Vasquez      2005-07-06   832  		handles[1] = mb[2];
^1da177e4c3f41 Linus Torvalds      2005-04-16   833  		handle_cnt = 2;
^1da177e4c3f41 Linus Torvalds      2005-04-16   834  		mb[0] = MBA_SCSI_COMPLETION;
^1da177e4c3f41 Linus Torvalds      2005-04-16   835  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   836  	case MBA_CMPLT_3_16BIT:
9a853f71804d80 Andrew Vasquez      2005-07-06   837  		handles[0] = mb[1];
9a853f71804d80 Andrew Vasquez      2005-07-06   838  		handles[1] = mb[2];
9a853f71804d80 Andrew Vasquez      2005-07-06   839  		handles[2] = mb[3];
^1da177e4c3f41 Linus Torvalds      2005-04-16   840  		handle_cnt = 3;
^1da177e4c3f41 Linus Torvalds      2005-04-16   841  		mb[0] = MBA_SCSI_COMPLETION;
^1da177e4c3f41 Linus Torvalds      2005-04-16   842  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   843  	case MBA_CMPLT_4_16BIT:
9a853f71804d80 Andrew Vasquez      2005-07-06   844  		handles[0] = mb[1];
9a853f71804d80 Andrew Vasquez      2005-07-06   845  		handles[1] = mb[2];
9a853f71804d80 Andrew Vasquez      2005-07-06   846  		handles[2] = mb[3];
^1da177e4c3f41 Linus Torvalds      2005-04-16   847  		handles[3] = (uint32_t)RD_MAILBOX_REG(ha, reg, 6);
^1da177e4c3f41 Linus Torvalds      2005-04-16   848  		handle_cnt = 4;
^1da177e4c3f41 Linus Torvalds      2005-04-16   849  		mb[0] = MBA_SCSI_COMPLETION;
^1da177e4c3f41 Linus Torvalds      2005-04-16   850  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   851  	case MBA_CMPLT_5_16BIT:
9a853f71804d80 Andrew Vasquez      2005-07-06   852  		handles[0] = mb[1];
9a853f71804d80 Andrew Vasquez      2005-07-06   853  		handles[1] = mb[2];
9a853f71804d80 Andrew Vasquez      2005-07-06   854  		handles[2] = mb[3];
^1da177e4c3f41 Linus Torvalds      2005-04-16   855  		handles[3] = (uint32_t)RD_MAILBOX_REG(ha, reg, 6);
^1da177e4c3f41 Linus Torvalds      2005-04-16   856  		handles[4] = (uint32_t)RD_MAILBOX_REG(ha, reg, 7);
^1da177e4c3f41 Linus Torvalds      2005-04-16   857  		handle_cnt = 5;
^1da177e4c3f41 Linus Torvalds      2005-04-16   858  		mb[0] = MBA_SCSI_COMPLETION;
^1da177e4c3f41 Linus Torvalds      2005-04-16   859  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   860  	case MBA_CMPLT_2_32BIT:
9a853f71804d80 Andrew Vasquez      2005-07-06   861  		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
^1da177e4c3f41 Linus Torvalds      2005-04-16   862  		handles[1] = le32_to_cpu(
^1da177e4c3f41 Linus Torvalds      2005-04-16   863  		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
^1da177e4c3f41 Linus Torvalds      2005-04-16   864  		    RD_MAILBOX_REG(ha, reg, 6));
^1da177e4c3f41 Linus Torvalds      2005-04-16   865  		handle_cnt = 2;
^1da177e4c3f41 Linus Torvalds      2005-04-16   866  		mb[0] = MBA_SCSI_COMPLETION;
^1da177e4c3f41 Linus Torvalds      2005-04-16   867  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   868  	default:
^1da177e4c3f41 Linus Torvalds      2005-04-16   869  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   870  	}
3a03eb797ce76a Andrew Vasquez      2009-01-05   871  skip_rio:
^1da177e4c3f41 Linus Torvalds      2005-04-16   872  	switch (mb[0]) {
^1da177e4c3f41 Linus Torvalds      2005-04-16   873  	case MBA_SCSI_COMPLETION:	/* Fast Post */
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   874  		if (!vha->flags.online)
^1da177e4c3f41 Linus Torvalds      2005-04-16   875  			break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   876  
^1da177e4c3f41 Linus Torvalds      2005-04-16   877  		for (cnt = 0; cnt < handle_cnt; cnt++)
73208dfd7ab19f Anirban Chakraborty 2008-12-09   878  			qla2x00_process_completed_request(vha, rsp->req,
73208dfd7ab19f Anirban Chakraborty 2008-12-09   879  				handles[cnt]);
^1da177e4c3f41 Linus Torvalds      2005-04-16   880  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   881  
^1da177e4c3f41 Linus Torvalds      2005-04-16   882  	case MBA_RESET:			/* Reset */
7c3df1320e5e87 Saurav Kashyap      2011-07-14   883  		ql_dbg(ql_dbg_async, vha, 0x5002,
7c3df1320e5e87 Saurav Kashyap      2011-07-14   884  		    "Asynchronous RESET.\n");
^1da177e4c3f41 Linus Torvalds      2005-04-16   885  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   886  		set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16   887  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   888  
^1da177e4c3f41 Linus Torvalds      2005-04-16   889  	case MBA_SYSTEM_ERR:		/* System Error */
a82c307e69c465 Quinn Tran          2020-02-26   890  		mbx = 0;
a82c307e69c465 Quinn Tran          2020-02-26   891  		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
a82c307e69c465 Quinn Tran          2020-02-26   892  		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
a82c307e69c465 Quinn Tran          2020-02-26   893  			u16 m[4];
a82c307e69c465 Quinn Tran          2020-02-26   894  
a82c307e69c465 Quinn Tran          2020-02-26   895  			m[0] = RD_REG_WORD(&reg24->mailbox4);
a82c307e69c465 Quinn Tran          2020-02-26   896  			m[1] = RD_REG_WORD(&reg24->mailbox5);
a82c307e69c465 Quinn Tran          2020-02-26   897  			m[2] = RD_REG_WORD(&reg24->mailbox6);
a82c307e69c465 Quinn Tran          2020-02-26   898  			mbx = m[3] = RD_REG_WORD(&reg24->mailbox7);
a82c307e69c465 Quinn Tran          2020-02-26   899  
7c3df1320e5e87 Saurav Kashyap      2011-07-14   900  			ql_log(ql_log_warn, vha, 0x5003,
a82c307e69c465 Quinn Tran          2020-02-26   901  			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh mbx4=%xh mbx5=%xh mbx6=%xh mbx7=%xh.\n",
a82c307e69c465 Quinn Tran          2020-02-26   902  			    mb[1], mb[2], mb[3], m[0], m[1], m[2], m[3]);
a82c307e69c465 Quinn Tran          2020-02-26  @903  		} else
a82c307e69c465 Quinn Tran          2020-02-26   904  			ql_log(ql_log_warn, vha, 0x5003,
a82c307e69c465 Quinn Tran          2020-02-26   905  			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n ",
a82c307e69c465 Quinn Tran          2020-02-26   906  			    mb[1], mb[2], mb[3]);
a82c307e69c465 Quinn Tran          2020-02-26   907  
ff3a920efcdbfa Arun Easi           2020-03-27   908  			if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
ff3a920efcdbfa Arun Easi           2020-03-27   909  			   RD_REG_WORD(&reg24->mailbox7) & BIT_8)
ff3a920efcdbfa Arun Easi           2020-03-27   910  				ha->isp_ops->mpi_fw_dump(vha, 1);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   911  		ha->isp_ops->fw_dump(vha, 1);
ec7193e2605511 Quinn Tran          2017-03-15   912  		ha->flags.fw_init_done = 0;
4b60c82736d0e2 Quinn Tran          2017-06-13   913  		QLA_FW_STOPPED(ha);
^1da177e4c3f41 Linus Torvalds      2005-04-16   914  
e428924ccdf464 Andrew Vasquez      2007-07-19   915  		if (IS_FWI2_CAPABLE(ha)) {
9a853f71804d80 Andrew Vasquez      2005-07-06   916  			if (mb[1] == 0 && mb[2] == 0) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14   917  				ql_log(ql_log_fatal, vha, 0x5004,
9a853f71804d80 Andrew Vasquez      2005-07-06   918  				    "Unrecoverable Hardware Error: adapter "
9a853f71804d80 Andrew Vasquez      2005-07-06   919  				    "marked OFFLINE!\n");
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   920  				vha->flags.online = 0;
6246b8a1d26c7c Giridhar Malavali   2012-02-09   921  				vha->device_flags |= DFLG_DEV_FAILED;
b1d46989c12ec4 Madhuranath Iyengar 2010-09-03   922  			} else {
25985edcedea63 Lucas De Marchi     2011-03-30   923  				/* Check to see if MPI timeout occurred */
f73cb695d3eccd Chad Dupuis         2014-02-26   924  				if ((mbx & MBX_3) && (ha->port_no == 0))
b1d46989c12ec4 Madhuranath Iyengar 2010-09-03   925  					set_bit(MPI_RESET_NEEDED,
b1d46989c12ec4 Madhuranath Iyengar 2010-09-03   926  					    &vha->dpc_flags);
b1d46989c12ec4 Madhuranath Iyengar 2010-09-03   927  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   928  				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
b1d46989c12ec4 Madhuranath Iyengar 2010-09-03   929  			}
9a853f71804d80 Andrew Vasquez      2005-07-06   930  		} else if (mb[1] == 0) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14   931  			ql_log(ql_log_fatal, vha, 0x5005,
^1da177e4c3f41 Linus Torvalds      2005-04-16   932  			    "Unrecoverable Hardware Error: adapter marked "
^1da177e4c3f41 Linus Torvalds      2005-04-16   933  			    "OFFLINE!\n");
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   934  			vha->flags.online = 0;
6246b8a1d26c7c Giridhar Malavali   2012-02-09   935  			vha->device_flags |= DFLG_DEV_FAILED;
^1da177e4c3f41 Linus Torvalds      2005-04-16   936  		} else
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   937  			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16   938  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   939  
^1da177e4c3f41 Linus Torvalds      2005-04-16   940  	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
7c3df1320e5e87 Saurav Kashyap      2011-07-14   941  		ql_log(ql_log_warn, vha, 0x5006,
bdab23da71c369 Andrew Vasquez      2009-10-13   942  		    "ISP Request Transfer Error (%x).\n",  mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16   943  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   944  		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16   945  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   946  
^1da177e4c3f41 Linus Torvalds      2005-04-16   947  	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
7c3df1320e5e87 Saurav Kashyap      2011-07-14   948  		ql_log(ql_log_warn, vha, 0x5007,
41233cd3a454b6 Joe Carnuccio       2016-07-06   949  		    "ISP Response Transfer Error (%x).\n", mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16   950  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   951  		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16   952  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   953  
^1da177e4c3f41 Linus Torvalds      2005-04-16   954  	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
7c3df1320e5e87 Saurav Kashyap      2011-07-14   955  		ql_dbg(ql_dbg_async, vha, 0x5008,
41233cd3a454b6 Joe Carnuccio       2016-07-06   956  		    "Asynchronous WAKEUP_THRES (%x).\n", mb[1]);
41233cd3a454b6 Joe Carnuccio       2016-07-06   957  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   958  
41233cd3a454b6 Joe Carnuccio       2016-07-06   959  	case MBA_LOOP_INIT_ERR:
75d560e0952466 Sawan Chandak       2016-07-06   960  		ql_log(ql_log_warn, vha, 0x5090,
41233cd3a454b6 Joe Carnuccio       2016-07-06   961  		    "LOOP INIT ERROR (%x).\n", mb[1]);
41233cd3a454b6 Joe Carnuccio       2016-07-06   962  		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
2d70c103fd2a06 Nicholas Bellinger  2012-05-15   963  		break;
41233cd3a454b6 Joe Carnuccio       2016-07-06   964  
^1da177e4c3f41 Linus Torvalds      2005-04-16   965  	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
ec7193e2605511 Quinn Tran          2017-03-15   966  		ha->flags.lip_ae = 1;
ec7193e2605511 Quinn Tran          2017-03-15   967  
cfb0919c12a331 Chad Dupuis         2011-11-18   968  		ql_dbg(ql_dbg_async, vha, 0x5009,
7c3df1320e5e87 Saurav Kashyap      2011-07-14   969  		    "LIP occurred (%x).\n", mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16   970  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   971  		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   972  			atomic_set(&vha->loop_state, LOOP_DOWN);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   973  			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17   974  			qla2x00_mark_all_devices_lost(vha);
^1da177e4c3f41 Linus Torvalds      2005-04-16   975  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16   976  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   977  		if (vha->vp_idx) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   978  			atomic_set(&vha->vp_state, VP_FAILED);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   979  			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
2c3dfe3f6ad8da Seokmann Ju         2007-07-05   980  		}
2c3dfe3f6ad8da Seokmann Ju         2007-07-05   981  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   982  		set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   983  		set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16   984  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   985  		vha->flags.management_server_logged_in = 0;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06   986  		qla2x00_post_aen_work(vha, FCH_EVT_LIP, mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16   987  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16   988  
^1da177e4c3f41 Linus Torvalds      2005-04-16   989  	case MBA_LOOP_UP:		/* Loop Up Event */
daae62a33e4f9b Chad Dupuis         2012-05-15   990  		if (IS_QLA2100(ha) || IS_QLA2200(ha))
d8b4521349274a Andrew Vasquez      2006-10-02   991  			ha->link_data_rate = PORT_SPEED_1GB;
daae62a33e4f9b Chad Dupuis         2012-05-15   992  		else
^1da177e4c3f41 Linus Torvalds      2005-04-16   993  			ha->link_data_rate = mb[1];
^1da177e4c3f41 Linus Torvalds      2005-04-16   994  
8e5a9484aee8d4 Chad Dupuis         2014-08-08   995  		ql_log(ql_log_info, vha, 0x500a,
daae62a33e4f9b Chad Dupuis         2012-05-15   996  		    "LOOP UP detected (%s Gbps).\n",
d0297c9a3f429d Joe Carnuccio       2012-11-21   997  		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
^1da177e4c3f41 Linus Torvalds      2005-04-16   998  
75666f4a8c4103 Himanshu Madhani    2020-02-12   999  		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
75666f4a8c4103 Himanshu Madhani    2020-02-12  1000  			if (mb[2] & BIT_0)
75666f4a8c4103 Himanshu Madhani    2020-02-12  1001  				ql_log(ql_log_info, vha, 0x11a0,
75666f4a8c4103 Himanshu Madhani    2020-02-12  1002  				    "FEC=enabled (link up).\n");
75666f4a8c4103 Himanshu Madhani    2020-02-12  1003  		}
75666f4a8c4103 Himanshu Madhani    2020-02-12  1004  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1005  		vha->flags.management_server_logged_in = 0;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1006  		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, ha->link_data_rate);
e4e3a2ce9556cc Quinn Tran          2017-08-23  1007  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1008  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1009  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1010  	case MBA_LOOP_DOWN:		/* Loop Down Event */
9cd883f07a54e5 Quinn Tran          2017-12-28  1011  		SAVE_TOPO(ha);
ec7193e2605511 Quinn Tran          2017-03-15  1012  		ha->flags.lip_ae = 0;
ec7193e2605511 Quinn Tran          2017-03-15  1013  		ha->current_topology = 0;
ec7193e2605511 Quinn Tran          2017-03-15  1014  
6246b8a1d26c7c Giridhar Malavali   2012-02-09  1015  		mbx = (IS_QLA81XX(ha) || IS_QLA8031(ha))
6246b8a1d26c7c Giridhar Malavali   2012-02-09  1016  			? RD_REG_WORD(&reg24->mailbox4) : 0;
7ec0effd30bb4b Atul Deshmukh       2013-08-27  1017  		mbx = (IS_P3P_TYPE(ha)) ? RD_REG_WORD(&reg82->mailbox_out[4])
7ec0effd30bb4b Atul Deshmukh       2013-08-27  1018  			: mbx;
8e5a9484aee8d4 Chad Dupuis         2014-08-08  1019  		ql_log(ql_log_info, vha, 0x500b,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1020  		    "LOOP DOWN detected (%x %x %x %x).\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1021  		    mb[1], mb[2], mb[3], mbx);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1022  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1023  		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1024  			atomic_set(&vha->loop_state, LOOP_DOWN);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1025  			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
2486c62765d73a Himanshu Madhani    2014-09-25  1026  			/*
2486c62765d73a Himanshu Madhani    2014-09-25  1027  			 * In case of loop down, restore WWPN from
2486c62765d73a Himanshu Madhani    2014-09-25  1028  			 * NVRAM in case of FA-WWPN capable ISP
718abbdca79f8a Sawan Chandak       2015-04-09  1029  			 * Restore for Physical Port only
2486c62765d73a Himanshu Madhani    2014-09-25  1030  			 */
718abbdca79f8a Sawan Chandak       2015-04-09  1031  			if (!vha->vp_idx) {
dcbf8f8087ebc4 Sawan Chandak       2019-01-24  1032  				if (ha->flags.fawwpn_enabled &&
dcbf8f8087ebc4 Sawan Chandak       2019-01-24  1033  				    (ha->current_topology == ISP_CFG_F)) {
2486c62765d73a Himanshu Madhani    2014-09-25  1034  					void *wwpn = ha->init_cb->port_name;
bd432bb53cffea Bart Van Assche     2019-04-11  1035  
2486c62765d73a Himanshu Madhani    2014-09-25  1036  					memcpy(vha->port_name, wwpn, WWN_SIZE);
718abbdca79f8a Sawan Chandak       2015-04-09  1037  					fc_host_port_name(vha->host) =
718abbdca79f8a Sawan Chandak       2015-04-09  1038  					    wwn_to_u64(vha->port_name);
718abbdca79f8a Sawan Chandak       2015-04-09  1039  					ql_dbg(ql_dbg_init + ql_dbg_verbose,
83548fe2fcbb78 Quinn Tran          2017-06-02  1040  					    vha, 0x00d8, "LOOP DOWN detected,"
718abbdca79f8a Sawan Chandak       2015-04-09  1041  					    "restore WWPN %016llx\n",
718abbdca79f8a Sawan Chandak       2015-04-09  1042  					    wwn_to_u64(vha->port_name));
2486c62765d73a Himanshu Madhani    2014-09-25  1043  				}
2486c62765d73a Himanshu Madhani    2014-09-25  1044  
ded6411fd88267 Sawan Chandak       2015-04-09  1045  				clear_bit(VP_CONFIG_OK, &vha->vp_flags);
718abbdca79f8a Sawan Chandak       2015-04-09  1046  			}
718abbdca79f8a Sawan Chandak       2015-04-09  1047  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1048  			vha->device_flags |= DFLG_NO_CABLE;
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17  1049  			qla2x00_mark_all_devices_lost(vha);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1050  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1051  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1052  		if (vha->vp_idx) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1053  			atomic_set(&vha->vp_state, VP_FAILED);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1054  			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1055  		}
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1056  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1057  		vha->flags.management_server_logged_in = 0;
d8b4521349274a Andrew Vasquez      2006-10-02  1058  		ha->link_data_rate = PORT_SPEED_UNKNOWN;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1059  		qla2x00_post_aen_work(vha, FCH_EVT_LINKDOWN, 0);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1060  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1061  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1062  	case MBA_LIP_RESET:		/* LIP reset occurred */
cfb0919c12a331 Chad Dupuis         2011-11-18  1063  		ql_dbg(ql_dbg_async, vha, 0x500c,
cc3ef7bc40bbed Bjorn Helgaas       2008-09-11  1064  		    "LIP reset occurred (%x).\n", mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1065  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1066  		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1067  			atomic_set(&vha->loop_state, LOOP_DOWN);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1068  			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17  1069  			qla2x00_mark_all_devices_lost(vha);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1070  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1071  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1072  		if (vha->vp_idx) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1073  			atomic_set(&vha->vp_state, VP_FAILED);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1074  			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1075  		}
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1076  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1077  		set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1078  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1079  		ha->operating_mode = LOOP;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1080  		vha->flags.management_server_logged_in = 0;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1081  		qla2x00_post_aen_work(vha, FCH_EVT_LIPRESET, mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1082  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1083  
3a03eb797ce76a Andrew Vasquez      2009-01-05  1084  	/* case MBA_DCBX_COMPLETE: */
^1da177e4c3f41 Linus Torvalds      2005-04-16  1085  	case MBA_POINT_TO_POINT:	/* Point-to-Point */
ec7193e2605511 Quinn Tran          2017-03-15  1086  		ha->flags.lip_ae = 0;
ec7193e2605511 Quinn Tran          2017-03-15  1087  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1088  		if (IS_QLA2100(ha))
^1da177e4c3f41 Linus Torvalds      2005-04-16  1089  			break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1090  
7ec0effd30bb4b Atul Deshmukh       2013-08-27  1091  		if (IS_CNA_CAPABLE(ha)) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1092  			ql_dbg(ql_dbg_async, vha, 0x500d,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1093  			    "DCBX Completed -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1094  			    mb[1], mb[2], mb[3]);
9aaf2cea4e63ed Chad Dupuis         2013-10-30  1095  			if (ha->notify_dcbx_comp && !vha->vp_idx)
23f2ebd17a1383 Sarang Radke        2010-05-28  1096  				complete(&ha->dcbx_comp);
23f2ebd17a1383 Sarang Radke        2010-05-28  1097  
23f2ebd17a1383 Sarang Radke        2010-05-28  1098  		} else
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1099  			ql_dbg(ql_dbg_async, vha, 0x500e,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1100  			    "Asynchronous P2P MODE received.\n");
^1da177e4c3f41 Linus Torvalds      2005-04-16  1101  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1102  		/*
^1da177e4c3f41 Linus Torvalds      2005-04-16  1103  		 * Until there's a transition from loop down to loop up, treat
^1da177e4c3f41 Linus Torvalds      2005-04-16  1104  		 * this as loop down only.
^1da177e4c3f41 Linus Torvalds      2005-04-16  1105  		 */
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1106  		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1107  			atomic_set(&vha->loop_state, LOOP_DOWN);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1108  			if (!atomic_read(&vha->loop_down_timer))
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1109  				atomic_set(&vha->loop_down_timer,
^1da177e4c3f41 Linus Torvalds      2005-04-16  1110  				    LOOP_DOWN_TIME);
48acad09907498 Quinn Tran          2018-08-02  1111  			if (!N2N_TOPO(ha))
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17  1112  				qla2x00_mark_all_devices_lost(vha);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1113  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1114  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1115  		if (vha->vp_idx) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1116  			atomic_set(&vha->vp_state, VP_FAILED);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1117  			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1118  		}
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1119  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1120  		if (!(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)))
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1121  			set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1122  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1123  		set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1124  		set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
4346b14942dbb6 Andrew Vasquez      2006-12-13  1125  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1126  		vha->flags.management_server_logged_in = 0;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1127  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1128  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1129  	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode */
^1da177e4c3f41 Linus Torvalds      2005-04-16  1130  		if (IS_QLA2100(ha))
^1da177e4c3f41 Linus Torvalds      2005-04-16  1131  			break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1132  
cfb0919c12a331 Chad Dupuis         2011-11-18  1133  		ql_dbg(ql_dbg_async, vha, 0x500f,
^1da177e4c3f41 Linus Torvalds      2005-04-16  1134  		    "Configuration change detected: value=%x.\n", mb[1]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1135  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1136  		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1137  			atomic_set(&vha->loop_state, LOOP_DOWN);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1138  			if (!atomic_read(&vha->loop_down_timer))
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1139  				atomic_set(&vha->loop_down_timer,
^1da177e4c3f41 Linus Torvalds      2005-04-16  1140  				    LOOP_DOWN_TIME);
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17  1141  			qla2x00_mark_all_devices_lost(vha);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1142  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1143  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1144  		if (vha->vp_idx) {
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1145  			atomic_set(&vha->vp_state, VP_FAILED);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1146  			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1147  		}
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1148  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1149  		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1150  		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1151  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1152  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1153  	case MBA_PORT_UPDATE:		/* Port database update */
55903b9d152e91 Santosh Vernekar    2009-07-31  1154  		/*
55903b9d152e91 Santosh Vernekar    2009-07-31  1155  		 * Handle only global and vn-port update events
55903b9d152e91 Santosh Vernekar    2009-07-31  1156  		 *
55903b9d152e91 Santosh Vernekar    2009-07-31  1157  		 * Relevant inputs:
55903b9d152e91 Santosh Vernekar    2009-07-31  1158  		 * mb[1] = N_Port handle of changed port
55903b9d152e91 Santosh Vernekar    2009-07-31  1159  		 * OR 0xffff for global event
55903b9d152e91 Santosh Vernekar    2009-07-31  1160  		 * mb[2] = New login state
55903b9d152e91 Santosh Vernekar    2009-07-31  1161  		 * 7 = Port logged out
55903b9d152e91 Santosh Vernekar    2009-07-31  1162  		 * mb[3] = LSB is vp_idx, 0xff = all vps
55903b9d152e91 Santosh Vernekar    2009-07-31  1163  		 *
55903b9d152e91 Santosh Vernekar    2009-07-31  1164  		 * Skip processing if:
55903b9d152e91 Santosh Vernekar    2009-07-31  1165  		 *       Event is global, vp_idx is NOT all vps,
55903b9d152e91 Santosh Vernekar    2009-07-31  1166  		 *           vp_idx does not match
55903b9d152e91 Santosh Vernekar    2009-07-31  1167  		 *       Event is not global, vp_idx does not match
55903b9d152e91 Santosh Vernekar    2009-07-31  1168  		 */
12cec63e40f9b9 Andrew Vasquez      2010-03-19  1169  		if (IS_QLA2XXX_MIDTYPE(ha) &&
12cec63e40f9b9 Andrew Vasquez      2010-03-19  1170  		    ((mb[1] == 0xffff && (mb[3] & 0xff) != 0xff) ||
12cec63e40f9b9 Andrew Vasquez      2010-03-19  1171  			(mb[1] != 0xffff)) && vha->vp_idx != (mb[3] & 0xff))
73208dfd7ab19f Anirban Chakraborty 2008-12-09  1172  			break;
73208dfd7ab19f Anirban Chakraborty 2008-12-09  1173  
17cac3a175a02c Joe Carnuccio       2015-08-04  1174  		if (mb[2] == 0x7) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1175  			ql_dbg(ql_dbg_async, vha, 0x5010,
17cac3a175a02c Joe Carnuccio       2015-08-04  1176  			    "Port %s %04x %04x %04x.\n",
17cac3a175a02c Joe Carnuccio       2015-08-04  1177  			    mb[1] == 0xffff ? "unavailable" : "logout",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1178  			    mb[1], mb[2], mb[3]);
17cac3a175a02c Joe Carnuccio       2015-08-04  1179  
17cac3a175a02c Joe Carnuccio       2015-08-04  1180  			if (mb[1] == 0xffff)
17cac3a175a02c Joe Carnuccio       2015-08-04  1181  				goto global_port_update;
17cac3a175a02c Joe Carnuccio       2015-08-04  1182  
b98ae0d748dbc8 Quinn Tran          2017-06-02  1183  			if (mb[1] == NPH_SNS_LID(ha)) {
b98ae0d748dbc8 Quinn Tran          2017-06-02  1184  				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
b98ae0d748dbc8 Quinn Tran          2017-06-02  1185  				set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
b98ae0d748dbc8 Quinn Tran          2017-06-02  1186  				break;
b98ae0d748dbc8 Quinn Tran          2017-06-02  1187  			}
b98ae0d748dbc8 Quinn Tran          2017-06-02  1188  
b98ae0d748dbc8 Quinn Tran          2017-06-02  1189  			/* use handle_cnt for loop id/nport handle */
b98ae0d748dbc8 Quinn Tran          2017-06-02  1190  			if (IS_FWI2_CAPABLE(ha))
b98ae0d748dbc8 Quinn Tran          2017-06-02  1191  				handle_cnt = NPH_SNS;
b98ae0d748dbc8 Quinn Tran          2017-06-02  1192  			else
b98ae0d748dbc8 Quinn Tran          2017-06-02  1193  				handle_cnt = SIMPLE_NAME_SERVER;
b98ae0d748dbc8 Quinn Tran          2017-06-02  1194  			if (mb[1] == handle_cnt) {
b98ae0d748dbc8 Quinn Tran          2017-06-02  1195  				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
b98ae0d748dbc8 Quinn Tran          2017-06-02  1196  				set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
b98ae0d748dbc8 Quinn Tran          2017-06-02  1197  				break;
b98ae0d748dbc8 Quinn Tran          2017-06-02  1198  			}
b98ae0d748dbc8 Quinn Tran          2017-06-02  1199  
17cac3a175a02c Joe Carnuccio       2015-08-04  1200  			/* Port logout */
17cac3a175a02c Joe Carnuccio       2015-08-04  1201  			fcport = qla2x00_find_fcport_by_loopid(vha, mb[1]);
17cac3a175a02c Joe Carnuccio       2015-08-04  1202  			if (!fcport)
17cac3a175a02c Joe Carnuccio       2015-08-04  1203  				break;
17cac3a175a02c Joe Carnuccio       2015-08-04  1204  			if (atomic_read(&fcport->state) != FCS_ONLINE)
17cac3a175a02c Joe Carnuccio       2015-08-04  1205  				break;
17cac3a175a02c Joe Carnuccio       2015-08-04  1206  			ql_dbg(ql_dbg_async, vha, 0x508a,
17cac3a175a02c Joe Carnuccio       2015-08-04  1207  			    "Marking port lost loopid=%04x portid=%06x.\n",
17cac3a175a02c Joe Carnuccio       2015-08-04  1208  			    fcport->loop_id, fcport->d_id.b24);
726b85487067d7 Quinn Tran          2017-01-19  1209  			if (qla_ini_mode_enabled(vha)) {
726b85487067d7 Quinn Tran          2017-01-19  1210  				fcport->logout_on_delete = 0;
d8630bb95f46ea Quinn Tran          2017-12-28  1211  				qlt_schedule_sess_for_deletion(fcport);
726b85487067d7 Quinn Tran          2017-01-19  1212  			}
17cac3a175a02c Joe Carnuccio       2015-08-04  1213  			break;
17cac3a175a02c Joe Carnuccio       2015-08-04  1214  
17cac3a175a02c Joe Carnuccio       2015-08-04  1215  global_port_update:
9764ff8807a245 Andrew Vasquez      2009-07-31  1216  			if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
9764ff8807a245 Andrew Vasquez      2009-07-31  1217  				atomic_set(&vha->loop_state, LOOP_DOWN);
9764ff8807a245 Andrew Vasquez      2009-07-31  1218  				atomic_set(&vha->loop_down_timer,
9764ff8807a245 Andrew Vasquez      2009-07-31  1219  				    LOOP_DOWN_TIME);
9764ff8807a245 Andrew Vasquez      2009-07-31  1220  				vha->device_flags |= DFLG_NO_CABLE;
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17  1221  				qla2x00_mark_all_devices_lost(vha);
9764ff8807a245 Andrew Vasquez      2009-07-31  1222  			}
9764ff8807a245 Andrew Vasquez      2009-07-31  1223  
9764ff8807a245 Andrew Vasquez      2009-07-31  1224  			if (vha->vp_idx) {
9764ff8807a245 Andrew Vasquez      2009-07-31  1225  				atomic_set(&vha->vp_state, VP_FAILED);
9764ff8807a245 Andrew Vasquez      2009-07-31  1226  				fc_vport_set_state(vha->fc_vport,
9764ff8807a245 Andrew Vasquez      2009-07-31  1227  				    FC_VPORT_FAILED);
3c75ad1d87c7d2 Himanshu Madhani    2019-12-17  1228  				qla2x00_mark_all_devices_lost(vha);
9764ff8807a245 Andrew Vasquez      2009-07-31  1229  			}
9764ff8807a245 Andrew Vasquez      2009-07-31  1230  
9764ff8807a245 Andrew Vasquez      2009-07-31  1231  			vha->flags.management_server_logged_in = 0;
9764ff8807a245 Andrew Vasquez      2009-07-31  1232  			ha->link_data_rate = PORT_SPEED_UNKNOWN;
9764ff8807a245 Andrew Vasquez      2009-07-31  1233  			break;
9764ff8807a245 Andrew Vasquez      2009-07-31  1234  		}
9764ff8807a245 Andrew Vasquez      2009-07-31  1235  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1236  		/*
cc3ef7bc40bbed Bjorn Helgaas       2008-09-11  1237  		 * If PORT UPDATE is global (received LIP_OCCURRED/LIP_RESET
^1da177e4c3f41 Linus Torvalds      2005-04-16  1238  		 * event etc. earlier indicating loop is down) then process
^1da177e4c3f41 Linus Torvalds      2005-04-16  1239  		 * it.  Otherwise ignore it and Wait for RSCN to come in.
^1da177e4c3f41 Linus Torvalds      2005-04-16  1240  		 */
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1241  		atomic_set(&vha->loop_down_timer, 0);
8e5a9484aee8d4 Chad Dupuis         2014-08-08  1242  		if (atomic_read(&vha->loop_state) != LOOP_DOWN &&
edd05de1975927 Duane Grigsby       2017-10-13  1243  			!ha->flags.n2n_ae  &&
8e5a9484aee8d4 Chad Dupuis         2014-08-08  1244  		    atomic_read(&vha->loop_state) != LOOP_DEAD) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1245  			ql_dbg(ql_dbg_async, vha, 0x5011,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1246  			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1247  			    mb[1], mb[2], mb[3]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1248  			break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1249  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1250  
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1251  		ql_dbg(ql_dbg_async, vha, 0x5012,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1252  		    "Port database changed %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1253  		    mb[1], mb[2], mb[3]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1254  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1255  		/*
^1da177e4c3f41 Linus Torvalds      2005-04-16  1256  		 * Mark all devices as missing so we will login again.
^1da177e4c3f41 Linus Torvalds      2005-04-16  1257  		 */
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1258  		atomic_set(&vha->loop_state, LOOP_UP);
6944dccbb7c9db Quinn Tran          2017-12-28  1259  		vha->scan.scan_retry = 0;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1260  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1261  		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1262  		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
ded6411fd88267 Sawan Chandak       2015-04-09  1263  		set_bit(VP_CONFIG_OK, &vha->vp_flags);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1264  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1265  
^1da177e4c3f41 Linus Torvalds      2005-04-16  1266  	case MBA_RSCN_UPDATE:		/* State Change Registration */
3c39740073b20d Seokmann Ju         2008-05-19  1267  		/* Check if the Vport has issued a SCR */
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1268  		if (vha->vp_idx && test_bit(VP_SCR_NEEDED, &vha->vp_flags))
3c39740073b20d Seokmann Ju         2008-05-19  1269  			break;
3c39740073b20d Seokmann Ju         2008-05-19  1270  		/* Only handle SCNs for our Vport index. */
0d6e61bc6a4f3f Andrew Vasquez      2009-08-25  1271  		if (ha->flags.npiv_supported && vha->vp_idx != (mb[3] & 0xff))
f4a8dbc7f6ca8c Shyam Sundar        2007-11-12  1272  			break;
0d6e61bc6a4f3f Andrew Vasquez      2009-08-25  1273  
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1274  		ql_dbg(ql_dbg_async, vha, 0x5013,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1275  		    "RSCN database changed -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1276  		    mb[1], mb[2], mb[3]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1277  
59d72d873ccfaf Ravi Anand          2008-09-11  1278  		rscn_entry = ((mb[1] & 0xff) << 16) | mb[2];
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1279  		host_pid = (vha->d_id.b.domain << 16) | (vha->d_id.b.area << 8)
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1280  				| vha->d_id.b.al_pa;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1281  		if (rscn_entry == host_pid) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1282  			ql_dbg(ql_dbg_async, vha, 0x5014,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1283  			    "Ignoring RSCN update to local host "
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1284  			    "port ID (%06x).\n", host_pid);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1285  			break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1286  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1287  
59d72d873ccfaf Ravi Anand          2008-09-11  1288  		/* Ignore reserved bits from RSCN-payload. */
59d72d873ccfaf Ravi Anand          2008-09-11  1289  		rscn_entry = ((mb[1] & 0x3ff) << 16) | mb[2];
^1da177e4c3f41 Linus Torvalds      2005-04-16  1290  
bb4cf5b73b47fe Chad Dupuis         2013-02-08  1291  		/* Skip RSCNs for virtual ports on the same physical port */
bb4cf5b73b47fe Chad Dupuis         2013-02-08  1292  		if (qla2x00_is_a_vp_did(vha, rscn_entry))
bb4cf5b73b47fe Chad Dupuis         2013-02-08  1293  			break;
bb4cf5b73b47fe Chad Dupuis         2013-02-08  1294  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1295  		atomic_set(&vha->loop_down_timer, 0);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1296  		vha->flags.management_server_logged_in = 0;
726b85487067d7 Quinn Tran          2017-01-19  1297  		{
726b85487067d7 Quinn Tran          2017-01-19  1298  			struct event_arg ea;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1299  
726b85487067d7 Quinn Tran          2017-01-19  1300  			memset(&ea, 0, sizeof(ea));
726b85487067d7 Quinn Tran          2017-01-19  1301  			ea.id.b24 = rscn_entry;
41dc529a4602ac Quinn Tran          2017-01-19  1302  			ea.id.b.rsvd_1 = rscn_entry >> 24;
897def20042136 Bart Van Assche     2019-08-08  1303  			qla2x00_handle_rscn(vha, &ea);
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1304  			qla2x00_post_aen_work(vha, FCH_EVT_RSCN, rscn_entry);
726b85487067d7 Quinn Tran          2017-01-19  1305  		}
^1da177e4c3f41 Linus Torvalds      2005-04-16  1306  		break;
^1da177e4c3f41 Linus Torvalds      2005-04-16  1307  	/* case MBA_RIO_RESPONSE: */
^1da177e4c3f41 Linus Torvalds      2005-04-16  1308  	case MBA_ZIO_RESPONSE:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1309  		ql_dbg(ql_dbg_async, vha, 0x5015,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1310  		    "[R|Z]IO update completion.\n");
^1da177e4c3f41 Linus Torvalds      2005-04-16  1311  
e428924ccdf464 Andrew Vasquez      2007-07-19  1312  		if (IS_FWI2_CAPABLE(ha))
2afa19a9377ca6 Anirban Chakraborty 2009-04-06  1313  			qla24xx_process_response_queue(vha, rsp);
4fdfefe52944f5 Andrew Vasquez      2005-10-27  1314  		else
73208dfd7ab19f Anirban Chakraborty 2008-12-09  1315  			qla2x00_process_response_queue(rsp);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1316  		break;
9a853f71804d80 Andrew Vasquez      2005-07-06  1317  
9a853f71804d80 Andrew Vasquez      2005-07-06  1318  	case MBA_DISCARD_RND_FRAME:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1319  		ql_dbg(ql_dbg_async, vha, 0x5016,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1320  		    "Discard RND Frame -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1321  		    mb[1], mb[2], mb[3]);
9a853f71804d80 Andrew Vasquez      2005-07-06  1322  		break;
45ebeb560570fd Andrew Vasquez      2006-08-01  1323  
45ebeb560570fd Andrew Vasquez      2006-08-01  1324  	case MBA_TRACE_NOTIFICATION:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1325  		ql_dbg(ql_dbg_async, vha, 0x5017,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1326  		    "Trace Notification -- %04x %04x.\n", mb[1], mb[2]);
45ebeb560570fd Andrew Vasquez      2006-08-01  1327  		break;
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1328  
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1329  	case MBA_ISP84XX_ALERT:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1330  		ql_dbg(ql_dbg_async, vha, 0x5018,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1331  		    "ISP84XX Alert Notification -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1332  		    mb[1], mb[2], mb[3]);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1333  
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1334  		spin_lock_irqsave(&ha->cs84xx->access_lock, flags);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1335  		switch (mb[1]) {
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1336  		case A84_PANIC_RECOVERY:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1337  			ql_log(ql_log_info, vha, 0x5019,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1338  			    "Alert 84XX: panic recovery %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1339  			    mb[2], mb[3]);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1340  			break;
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1341  		case A84_OP_LOGIN_COMPLETE:
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1342  			ha->cs84xx->op_fw_version = mb[3] << 16 | mb[2];
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1343  			ql_log(ql_log_info, vha, 0x501a,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1344  			    "Alert 84XX: firmware version %x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1345  			    ha->cs84xx->op_fw_version);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1346  			break;
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1347  		case A84_DIAG_LOGIN_COMPLETE:
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1348  			ha->cs84xx->diag_fw_version = mb[3] << 16 | mb[2];
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1349  			ql_log(ql_log_info, vha, 0x501b,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1350  			    "Alert 84XX: diagnostic firmware version %x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1351  			    ha->cs84xx->diag_fw_version);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1352  			break;
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1353  		case A84_GOLD_LOGIN_COMPLETE:
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1354  			ha->cs84xx->diag_fw_version = mb[3] << 16 | mb[2];
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1355  			ha->cs84xx->fw_update = 1;
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1356  			ql_log(ql_log_info, vha, 0x501c,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1357  			    "Alert 84XX: gold firmware version %x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1358  			    ha->cs84xx->gold_fw_version);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1359  			break;
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1360  		default:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1361  			ql_log(ql_log_warn, vha, 0x501d,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1362  			    "Alert 84xx: Invalid Alert %04x %04x %04x.\n",
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1363  			    mb[1], mb[2], mb[3]);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1364  		}
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1365  		spin_unlock_irqrestore(&ha->cs84xx->access_lock, flags);
4d4df1932b6b11 Harihara Kadayam    2008-04-03  1366  		break;
3a03eb797ce76a Andrew Vasquez      2009-01-05  1367  	case MBA_DCBX_START:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1368  		ql_dbg(ql_dbg_async, vha, 0x501e,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1369  		    "DCBX Started -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1370  		    mb[1], mb[2], mb[3]);
3a03eb797ce76a Andrew Vasquez      2009-01-05  1371  		break;
3a03eb797ce76a Andrew Vasquez      2009-01-05  1372  	case MBA_DCBX_PARAM_UPDATE:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1373  		ql_dbg(ql_dbg_async, vha, 0x501f,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1374  		    "DCBX Parameters Updated -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1375  		    mb[1], mb[2], mb[3]);
3a03eb797ce76a Andrew Vasquez      2009-01-05  1376  		break;
3a03eb797ce76a Andrew Vasquez      2009-01-05  1377  	case MBA_FCF_CONF_ERR:
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1378  		ql_dbg(ql_dbg_async, vha, 0x5020,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1379  		    "FCF Configuration Error -- %04x %04x %04x.\n",
7c3df1320e5e87 Saurav Kashyap      2011-07-14  1380  		    mb[1], mb[2], mb[3]);
3a03eb797ce76a Andrew Vasquez      2009-01-05  1381  		break;
3a03eb797ce76a Andrew Vasquez      2009-01-05  1382  	case MBA_IDC_NOTIFY:
7ec0effd30bb4b Atul Deshmukh       2013-08-27  1383  		if (IS_QLA8031(vha->hw) || IS_QLA8044(ha)) {
67b2a31f517a43 Chad Dupuis         2013-02-08  1384  			mb[4] = RD_REG_WORD(&reg24->mailbox4);
67b2a31f517a43 Chad Dupuis         2013-02-08  1385  			if (((mb[2] & 0x7fff) == MBC_PORT_RESET ||
67b2a31f517a43 Chad Dupuis         2013-02-08  1386  			    (mb[2] & 0x7fff) == MBC_SET_PORT_CONFIG) &&
67b2a31f517a43 Chad Dupuis         2013-02-08  1387  			    (mb[4] & INTERNAL_LOOPBACK_MASK) != 0) {
8fcd6b8b0fbc61 Chad Dupuis         2012-08-22  1388  				set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
67b2a31f517a43 Chad Dupuis         2013-02-08  1389  				/*
67b2a31f517a43 Chad Dupuis         2013-02-08  1390  				 * Extend loop down timer since port is active.
67b2a31f517a43 Chad Dupuis         2013-02-08  1391  				 */
67b2a31f517a43 Chad Dupuis         2013-02-08  1392  				if (atomic_read(&vha->loop_state) == LOOP_DOWN)
67b2a31f517a43 Chad Dupuis         2013-02-08  1393  					atomic_set(&vha->loop_down_timer,
67b2a31f517a43 Chad Dupuis         2013-02-08  1394  					    LOOP_DOWN_TIME);
8fcd6b8b0fbc61 Chad Dupuis         2012-08-22  1395  				qla2xxx_wake_dpc(vha);
8fcd6b8b0fbc61 Chad Dupuis         2012-08-22  1396  			}
67b2a31f517a43 Chad Dupuis         2013-02-08  1397  		}
81881861ae10ef Bart Van Assche     2017-12-07  1398  		/* fall through */
8fcd6b8b0fbc61 Chad Dupuis         2012-08-22  1399  	case MBA_IDC_COMPLETE:
9aaf2cea4e63ed Chad Dupuis         2013-10-30  1400  		if (ha->notify_lb_portup_comp && !vha->vp_idx)
f356bef134dda5 Chad Dupuis         2013-02-08  1401  			complete(&ha->lb_portup_comp);
f356bef134dda5 Chad Dupuis         2013-02-08  1402  		/* Fallthru */
3a03eb797ce76a Andrew Vasquez      2009-01-05  1403  	case MBA_IDC_TIME_EXT:
7ec0effd30bb4b Atul Deshmukh       2013-08-27  1404  		if (IS_QLA81XX(vha->hw) || IS_QLA8031(vha->hw) ||
7ec0effd30bb4b Atul Deshmukh       2013-08-27  1405  		    IS_QLA8044(ha))
8a659571eccfde Andrew Vasquez      2009-02-08  1406  			qla81xx_idc_event(vha, mb[0], mb[1]);
3a03eb797ce76a Andrew Vasquez      2009-01-05  1407  		break;
7d613ac6acec8c Santosh Vernekar    2012-08-22  1408  
7d613ac6acec8c Santosh Vernekar    2012-08-22  1409  	case MBA_IDC_AEN:
d52cd7747d905f Quinn Tran          2019-09-12  1410  		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
ff3a920efcdbfa Arun Easi           2020-03-27  1411  			qla27xx_handle_8200_aen(vha, mb);
d52cd7747d905f Quinn Tran          2019-09-12  1412  		} else if (IS_QLA83XX(ha)) {
7d613ac6acec8c Santosh Vernekar    2012-08-22  1413  			mb[4] = RD_REG_WORD(&reg24->mailbox4);
7d613ac6acec8c Santosh Vernekar    2012-08-22  1414  			mb[5] = RD_REG_WORD(&reg24->mailbox5);
7d613ac6acec8c Santosh Vernekar    2012-08-22  1415  			mb[6] = RD_REG_WORD(&reg24->mailbox6);
7d613ac6acec8c Santosh Vernekar    2012-08-22  1416  			mb[7] = RD_REG_WORD(&reg24->mailbox7);
7d613ac6acec8c Santosh Vernekar    2012-08-22  1417  			qla83xx_handle_8200_aen(vha, mb);
d52cd7747d905f Quinn Tran          2019-09-12  1418  		} else {
d52cd7747d905f Quinn Tran          2019-09-12  1419  			ql_dbg(ql_dbg_async, vha, 0x5052,
d52cd7747d905f Quinn Tran          2019-09-12  1420  			    "skip Heartbeat processing mb0-3=[0x%04x] [0x%04x] [0x%04x] [0x%04x]\n",
d52cd7747d905f Quinn Tran          2019-09-12  1421  			    mb[0], mb[1], mb[2], mb[3]);
d52cd7747d905f Quinn Tran          2019-09-12  1422  		}
7d613ac6acec8c Santosh Vernekar    2012-08-22  1423  		break;
7d613ac6acec8c Santosh Vernekar    2012-08-22  1424  
b5a340dd858b5b Joe Carnuccio       2014-09-25  1425  	case MBA_DPORT_DIAGNOSTICS:
b5a340dd858b5b Joe Carnuccio       2014-09-25  1426  		ql_dbg(ql_dbg_async, vha, 0x5052,
425215647fc53b Joe Carnuccio       2019-12-17  1427  		    "D-Port Diagnostics: %04x %04x %04x %04x\n",
425215647fc53b Joe Carnuccio       2019-12-17  1428  		    mb[0], mb[1], mb[2], mb[3]);
e6ad2b79b82f41 Joe Carnuccio       2020-02-12  1429  		memcpy(vha->dport_data, mb, sizeof(vha->dport_data));
425215647fc53b Joe Carnuccio       2019-12-17  1430  		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
425215647fc53b Joe Carnuccio       2019-12-17  1431  			static char *results[] = {
425215647fc53b Joe Carnuccio       2019-12-17  1432  			    "start", "done(pass)", "done(error)", "undefined" };
425215647fc53b Joe Carnuccio       2019-12-17  1433  			static char *types[] = {
425215647fc53b Joe Carnuccio       2019-12-17  1434  			    "none", "dynamic", "static", "other" };
425215647fc53b Joe Carnuccio       2019-12-17  1435  			uint result = mb[1] >> 0 & 0x3;
425215647fc53b Joe Carnuccio       2019-12-17  1436  			uint type = mb[1] >> 6 & 0x3;
425215647fc53b Joe Carnuccio       2019-12-17  1437  			uint sw = mb[1] >> 15 & 0x1;
425215647fc53b Joe Carnuccio       2019-12-17  1438  			ql_dbg(ql_dbg_async, vha, 0x5052,
425215647fc53b Joe Carnuccio       2019-12-17  1439  			    "D-Port Diagnostics: result=%s type=%s [sw=%u]\n",
425215647fc53b Joe Carnuccio       2019-12-17  1440  			    results[result], types[type], sw);
425215647fc53b Joe Carnuccio       2019-12-17  1441  			if (result == 2) {
425215647fc53b Joe Carnuccio       2019-12-17  1442  				static char *reasons[] = {
425215647fc53b Joe Carnuccio       2019-12-17  1443  				    "reserved", "unexpected reject",
425215647fc53b Joe Carnuccio       2019-12-17  1444  				    "unexpected phase", "retry exceeded",
425215647fc53b Joe Carnuccio       2019-12-17  1445  				    "timed out", "not supported",
425215647fc53b Joe Carnuccio       2019-12-17  1446  				    "user stopped" };
425215647fc53b Joe Carnuccio       2019-12-17  1447  				uint reason = mb[2] >> 0 & 0xf;
425215647fc53b Joe Carnuccio       2019-12-17  1448  				uint phase = mb[2] >> 12 & 0xf;
425215647fc53b Joe Carnuccio       2019-12-17  1449  				ql_dbg(ql_dbg_async, vha, 0x5052,
425215647fc53b Joe Carnuccio       2019-12-17  1450  				    "D-Port Diagnostics: reason=%s phase=%u \n",
425215647fc53b Joe Carnuccio       2019-12-17  1451  				    reason < 7 ? reasons[reason] : "other",
425215647fc53b Joe Carnuccio       2019-12-17  1452  				    phase >> 1);
425215647fc53b Joe Carnuccio       2019-12-17  1453  			}
425215647fc53b Joe Carnuccio       2019-12-17  1454  		}
b5a340dd858b5b Joe Carnuccio       2014-09-25  1455  		break;
b5a340dd858b5b Joe Carnuccio       2014-09-25  1456  
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1457  	case MBA_TEMPERATURE_ALERT:
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1458  		ql_dbg(ql_dbg_async, vha, 0x505e,
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1459  		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1460  		if (mb[1] == 0x12)
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1461  			schedule_work(&ha->board_disable);
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1462  		break;
a29b3dd7aa14fa Joe Carnuccio       2016-07-06  1463  
92d4408e34667f Sawan Chandak       2017-08-23  1464  	case MBA_TRANS_INSERT:
92d4408e34667f Sawan Chandak       2017-08-23  1465  		ql_dbg(ql_dbg_async, vha, 0x5091,
92d4408e34667f Sawan Chandak       2017-08-23  1466  		    "Transceiver Insertion: %04x\n", mb[1]);
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  1467  		set_bit(DETECT_SFP_CHANGE, &vha->dpc_flags);
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  1468  		break;
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  1469  
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  1470  	case MBA_TRANS_REMOVE:
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  1471  		ql_dbg(ql_dbg_async, vha, 0x5091, "Transceiver Removal\n");
92d4408e34667f Sawan Chandak       2017-08-23  1472  		break;
92d4408e34667f Sawan Chandak       2017-08-23  1473  
6246b8a1d26c7c Giridhar Malavali   2012-02-09  1474  	default:
6246b8a1d26c7c Giridhar Malavali   2012-02-09  1475  		ql_dbg(ql_dbg_async, vha, 0x5057,
6246b8a1d26c7c Giridhar Malavali   2012-02-09  1476  		    "Unknown AEN:%04x %04x %04x %04x\n",
6246b8a1d26c7c Giridhar Malavali   2012-02-09  1477  		    mb[0], mb[1], mb[2], mb[3]);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1478  	}
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  1479  
2d70c103fd2a06 Nicholas Bellinger  2012-05-15  1480  	qlt_async_event(mb[0], vha, mb);
2d70c103fd2a06 Nicholas Bellinger  2012-05-15  1481  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  1482  	if (!vha->vp_idx && ha->num_vhosts)
73208dfd7ab19f Anirban Chakraborty 2008-12-09  1483  		qla2x00_alert_all_vps(rsp, mb);
^1da177e4c3f41 Linus Torvalds      2005-04-16  1484  }
^1da177e4c3f41 Linus Torvalds      2005-04-16  1485  

:::::: The code at line 903 was first introduced by commit
:::::: a82c307e69c465e4d80cc15fde3c00f5b95832d6 scsi: qla2xxx: add more FW debug information

:::::: TO: Quinn Tran <qutran@marvell.com>
:::::: CC: Martin K. Petersen <martin.petersen@oracle.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--HlL+5n6rz5pIUxbD
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ByalAQA=

--HlL+5n6rz5pIUxbD--

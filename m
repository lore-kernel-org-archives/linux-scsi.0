Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C64C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 04:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 737FE22D05
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 04:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgHGEUt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 00:20:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:63774 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGEUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Aug 2020 00:20:48 -0400
IronPort-SDR: Nqp96YMId/qZKS1TLnrnjwXpw/E4VBhdIVvA2BhVcrhd78Ss0Jmy6KsGhGK8Ry9Jk09TOo+Et3
 nE5ztjJxxbVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="171062729"
X-IronPort-AV: E=Sophos;i="5.75,444,1589266800"; 
   d="gz'50?scan'50,208,50";a="171062729"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 21:19:42 -0700
IronPort-SDR: Q3DWGnWpcwQ8ptlOpSr/QSGktkE28iaWptYC6MN11zFV7oWPAZPbF83yrNLKNiuFSCb7t8zUrQ
 cOFMJtatwE5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,444,1589266800"; 
   d="gz'50?scan'50,208,50";a="331423076"
Received: from lkp-server02.sh.intel.com (HELO 37a337f97289) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Aug 2020 21:19:40 -0700
Received: from kbuild by 37a337f97289 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k3tr2-0001zY-3c; Fri, 07 Aug 2020 04:19:40 +0000
Date:   Fri, 7 Aug 2020 12:19:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [scsi:misc-base 244/307] drivers/scsi/bfa/bfad_bsg.c:3380:34:
 sparse: sparse: incorrect type in argument 2 (different address spaces)
Message-ID: <202008071225.sldhFkIU%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc-base
head:   bf1a28f92a8b00ee8ce48cc11338980e31ddb7b3
commit: 3bbd8ef9f780749426d4e52be0dfa3f70656d92b [244/307] scsi: bfa: Staticify all local functions
config: x86_64-randconfig-s022-20200806 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.2-117-g8c7aee71-dirty
        git checkout 3bbd8ef9f780749426d4e52be0dfa3f70656d92b
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/bfa/bfad_bsg.c:2391:25: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2391:25: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2391:25: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2391:25: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2391:25: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2391:25: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2414:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2414:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2414:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2414:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2415:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2415:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2415:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2415:38: sparse: sparse: cast to restricted __be16
   drivers/scsi/bfa/bfad_bsg.c:2417:33: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2417:33: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2417:33: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2417:33: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2417:33: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2417:33: sparse: sparse: cast to restricted __be32
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned int [usertype] scan_flags @@     got restricted blist_flags_t @@
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse:     expected unsigned int [usertype] scan_flags
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse:     got restricted blist_flags_t
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse: sparse: invalid assignment: |=
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse:    left side has type restricted blist_flags_t
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse:    right side has type unsigned int
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse: sparse: invalid assignment: &=
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse:    left side has type restricted blist_flags_t
   drivers/scsi/bfa/bfad_bsg.c:2551:9: sparse:    right side has type unsigned int
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned int [usertype] scan_flags @@     got restricted blist_flags_t @@
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse:     expected unsigned int [usertype] scan_flags
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse:     got restricted blist_flags_t
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse: sparse: invalid assignment: |=
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse:    left side has type restricted blist_flags_t
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse:    right side has type unsigned int
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse: sparse: invalid assignment: &=
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse:    left side has type restricted blist_flags_t
   drivers/scsi/bfa/bfad_bsg.c:2555:17: sparse:    right side has type unsigned int
>> drivers/scsi/bfa/bfad_bsg.c:3380:34: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void const [noderef] <asn:1> *from @@     got void * @@
>> drivers/scsi/bfa/bfad_bsg.c:3380:34: sparse:     expected void const [noderef] <asn:1> *from
   drivers/scsi/bfa/bfad_bsg.c:3380:34: sparse:     got void *
   drivers/scsi/bfa/bfad_bsg.c:3412:37: sparse: sparse: Using plain integer as NULL pointer
>> drivers/scsi/bfa/bfad_bsg.c:3534:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void [noderef] <asn:1> *to @@     got void * @@
>> drivers/scsi/bfa/bfad_bsg.c:3534:27: sparse:     expected void [noderef] <asn:1> *to
   drivers/scsi/bfa/bfad_bsg.c:3534:27: sparse:     got void *

vim +3380 drivers/scsi/bfa/bfad_bsg.c

b85daafe46eeb0 Krishna Gudipati   2011-06-13  3340  
3bbd8ef9f78074 Lee Jones          2020-07-21  3341  static int
75cc8cfc6e13d4 Johannes Thumshirn 2016-11-17  3342  bfad_im_bsg_els_ct_request(struct bsg_job *job)
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3343  {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3344  	struct bfa_bsg_data *bsg_data;
45349821ab3a8d Johannes Thumshirn 2017-11-28  3345  	struct Scsi_Host *shost = fc_bsg_to_shost(job);
48d83282db077f Arnd Bergmann      2017-12-06  3346  	struct bfad_im_port_s *im_port = bfad_get_im_port(shost);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3347  	struct bfad_s *bfad = im_port->bfad;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3348  	bfa_bsg_fcpt_t *bsg_fcpt;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3349  	struct bfad_fcxp    *drv_fcxp;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3350  	struct bfa_fcs_lport_s *fcs_port;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3351  	struct bfa_fcs_rport_s *fcs_rport;
4633773799940b Johannes Thumshirn 2017-01-10  3352  	struct fc_bsg_request *bsg_request = job->request;
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3353  	struct fc_bsg_reply *bsg_reply = job->reply;
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3354  	uint32_t command_type = bsg_request->msgcode;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3355  	unsigned long flags;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3356  	struct bfad_buf_info *rsp_buf_info;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3357  	void *req_kbuf = NULL, *rsp_kbuf = NULL;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3358  	int rc = -EINVAL;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3359  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3360  	job->reply_len  = sizeof(uint32_t);	/* Atleast uint32_t reply_len */
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3361  	bsg_reply->reply_payload_rcv_len = 0;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3362  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3363  	/* Get the payload passed in from userspace */
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3364  	bsg_data = (struct bfa_bsg_data *) (((char *)bsg_request) +
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3365  					    sizeof(struct fc_bsg_request));
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3366  	if (bsg_data == NULL)
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3367  		goto out;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3368  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3369  	/*
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3370  	 * Allocate buffer for bsg_fcpt and do a copy_from_user op for payload
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3371  	 * buffer of size bsg_data->payload_len
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3372  	 */
64b8aa75bc101e Jesper Juhl        2012-01-28  3373  	bsg_fcpt = kzalloc(bsg_data->payload_len, GFP_KERNEL);
529f9a765509c2 Krishna Gudipati   2012-07-13  3374  	if (!bsg_fcpt) {
529f9a765509c2 Krishna Gudipati   2012-07-13  3375  		rc = -ENOMEM;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3376  		goto out;
529f9a765509c2 Krishna Gudipati   2012-07-13  3377  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3378  
bccd2683df56dd Vijaya Mohan Guvva 2013-05-13  3379  	if (copy_from_user((uint8_t *)bsg_fcpt,
bccd2683df56dd Vijaya Mohan Guvva 2013-05-13 @3380  				(void *)(unsigned long)bsg_data->payload,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3381  				bsg_data->payload_len)) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3382  		kfree(bsg_fcpt);
529f9a765509c2 Krishna Gudipati   2012-07-13  3383  		rc = -EIO;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3384  		goto out;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3385  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3386  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3387  	drv_fcxp = kzalloc(sizeof(struct bfad_fcxp), GFP_KERNEL);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3388  	if (drv_fcxp == NULL) {
64b8aa75bc101e Jesper Juhl        2012-01-28  3389  		kfree(bsg_fcpt);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3390  		rc = -ENOMEM;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3391  		goto out;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3392  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3393  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3394  	spin_lock_irqsave(&bfad->bfad_lock, flags);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3395  	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, bsg_fcpt->vf_id,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3396  					bsg_fcpt->lpwwn);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3397  	if (fcs_port == NULL) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3398  		bsg_fcpt->status = BFA_STATUS_UNKNOWN_LWWN;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3399  		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3400  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3401  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3402  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3403  	/* Check if the port is online before sending FC Passthru cmd */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3404  	if (!bfa_fcs_lport_is_online(fcs_port)) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3405  		bsg_fcpt->status = BFA_STATUS_PORT_OFFLINE;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3406  		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3407  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3408  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3409  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3410  	drv_fcxp->port = fcs_port->bfad_port;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3411  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3412  	if (drv_fcxp->port->bfad == 0)
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3413  		drv_fcxp->port->bfad = bfad;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3414  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3415  	/* Fetch the bfa_rport - if nexus needed */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3416  	if (command_type == FC_BSG_HST_ELS_NOLOGIN ||
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3417  	    command_type == FC_BSG_HST_CT) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3418  		/* BSG HST commands: no nexus needed */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3419  		drv_fcxp->bfa_rport = NULL;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3420  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3421  	} else if (command_type == FC_BSG_RPT_ELS ||
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3422  		   command_type == FC_BSG_RPT_CT) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3423  		/* BSG RPT commands: nexus needed */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3424  		fcs_rport = bfa_fcs_lport_get_rport_by_pwwn(fcs_port,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3425  							    bsg_fcpt->dpwwn);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3426  		if (fcs_rport == NULL) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3427  			bsg_fcpt->status = BFA_STATUS_UNKNOWN_RWWN;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3428  			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3429  			goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3430  		}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3431  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3432  		drv_fcxp->bfa_rport = fcs_rport->bfa_rport;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3433  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3434  	} else { /* Unknown BSG msgcode; return -EINVAL */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3435  		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3436  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3437  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3438  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3439  	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3440  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3441  	/* allocate memory for req / rsp buffers */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3442  	req_kbuf = kzalloc(job->request_payload.payload_len, GFP_KERNEL);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3443  	if (!req_kbuf) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3444  		printk(KERN_INFO "bfa %s: fcpt request buffer alloc failed\n",
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3445  				bfad->pci_name);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3446  		rc = -ENOMEM;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3447  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3448  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3449  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3450  	rsp_kbuf = kzalloc(job->reply_payload.payload_len, GFP_KERNEL);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3451  	if (!rsp_kbuf) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3452  		printk(KERN_INFO "bfa %s: fcpt response buffer alloc failed\n",
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3453  				bfad->pci_name);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3454  		rc = -ENOMEM;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3455  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3456  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3457  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3458  	/* map req sg - copy the sg_list passed in to the linear buffer */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3459  	sg_copy_to_buffer(job->request_payload.sg_list,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3460  			  job->request_payload.sg_cnt, req_kbuf,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3461  			  job->request_payload.payload_len);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3462  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3463  	drv_fcxp->reqbuf_info = bfad_fcxp_map_sg(bfad, req_kbuf,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3464  					job->request_payload.payload_len,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3465  					&drv_fcxp->num_req_sgles);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3466  	if (!drv_fcxp->reqbuf_info) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3467  		printk(KERN_INFO "bfa %s: fcpt request fcxp_map_sg failed\n",
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3468  				bfad->pci_name);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3469  		rc = -ENOMEM;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3470  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3471  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3472  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3473  	drv_fcxp->req_sge = (struct bfa_sge_s *)
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3474  			    (((uint8_t *)drv_fcxp->reqbuf_info) +
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3475  			    (sizeof(struct bfad_buf_info) *
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3476  					drv_fcxp->num_req_sgles));
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3477  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3478  	/* map rsp sg */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3479  	drv_fcxp->rspbuf_info = bfad_fcxp_map_sg(bfad, rsp_kbuf,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3480  					job->reply_payload.payload_len,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3481  					&drv_fcxp->num_rsp_sgles);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3482  	if (!drv_fcxp->rspbuf_info) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3483  		printk(KERN_INFO "bfa %s: fcpt response fcxp_map_sg failed\n",
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3484  				bfad->pci_name);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3485  		rc = -ENOMEM;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3486  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3487  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3488  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3489  	rsp_buf_info = (struct bfad_buf_info *)drv_fcxp->rspbuf_info;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3490  	drv_fcxp->rsp_sge = (struct bfa_sge_s  *)
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3491  			    (((uint8_t *)drv_fcxp->rspbuf_info) +
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3492  			    (sizeof(struct bfad_buf_info) *
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3493  					drv_fcxp->num_rsp_sgles));
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3494  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3495  	/* fcxp send */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3496  	init_completion(&drv_fcxp->comp);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3497  	rc = bfad_fcxp_bsg_send(job, drv_fcxp, bsg_fcpt);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3498  	if (rc == BFA_STATUS_OK) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3499  		wait_for_completion(&drv_fcxp->comp);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3500  		bsg_fcpt->status = drv_fcxp->req_status;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3501  	} else {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3502  		bsg_fcpt->status = rc;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3503  		goto out_free_mem;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3504  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3505  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3506  	/* fill the job->reply data */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3507  	if (drv_fcxp->req_status == BFA_STATUS_OK) {
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3508  		job->reply_len = drv_fcxp->rsp_len;
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3509  		bsg_reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3510  		bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3511  	} else {
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3512  		bsg_reply->reply_payload_rcv_len =
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3513  					sizeof(struct fc_bsg_ctels_reply);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3514  		job->reply_len = sizeof(uint32_t);
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3515  		bsg_reply->reply_data.ctels_reply.status =
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3516  						FC_CTELS_STATUS_REJECT;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3517  	}
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3518  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3519  	/* Copy the response data to the reply_payload sg list */
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3520  	sg_copy_from_buffer(job->reply_payload.sg_list,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3521  			    job->reply_payload.sg_cnt,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3522  			    (uint8_t *)rsp_buf_info->virt,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3523  			    job->reply_payload.payload_len);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3524  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3525  out_free_mem:
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3526  	bfad_fcxp_free_mem(bfad, drv_fcxp->rspbuf_info,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3527  			   drv_fcxp->num_rsp_sgles);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3528  	bfad_fcxp_free_mem(bfad, drv_fcxp->reqbuf_info,
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3529  			   drv_fcxp->num_req_sgles);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3530  	kfree(req_kbuf);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3531  	kfree(rsp_kbuf);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3532  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3533  	/* Need a copy to user op */
bccd2683df56dd Vijaya Mohan Guvva 2013-05-13 @3534  	if (copy_to_user((void *)(unsigned long)bsg_data->payload,
bccd2683df56dd Vijaya Mohan Guvva 2013-05-13  3535  			(void *)bsg_fcpt, bsg_data->payload_len))
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3536  		rc = -EIO;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3537  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3538  	kfree(bsg_fcpt);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3539  	kfree(drv_fcxp);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3540  out:
01e0e15c8b3b32 Johannes Thumshirn 2016-11-17  3541  	bsg_reply->result = rc;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3542  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3543  	if (rc == BFA_STATUS_OK)
06548160dfecd1 Johannes Thumshirn 2016-11-17  3544  		bsg_job_done(job, bsg_reply->result,
1abaede71560fa Johannes Thumshirn 2016-11-17  3545  			       bsg_reply->reply_payload_rcv_len);
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3546  
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3547  	return rc;
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3548  }
b85daafe46eeb0 Krishna Gudipati   2011-06-13  3549  

:::::: The code at line 3380 was first introduced by commit
:::::: bccd2683df56ddce98964f93f6984df743004240 [SCSI] bfa: driver compatibility with 32bit libs

:::::: TO: Vijaya Mohan Guvva <vmohan@brocade.com>
:::::: CC: James Bottomley <JBottomley@Parallels.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--Q68bSM7Ycu6FN28Q
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--Q68bSM7Ycu6FN28Q--

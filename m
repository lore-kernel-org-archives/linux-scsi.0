Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795226631;
	b=weV5avT62mQpur61uepWsoLSUB+XXl0HEZwIzbqilIE7dFwD46ahvWcHvFOGT/CvnHQG
	 Jh2e1olGUB6CEOHrolQbiVObYYfprTauHmw58uNIdvhHfCPU08PIsK3txC3SSdjXwGkTy
	 eFtBZ+/VNPJeWuKBk5epjRLASB8qOPse17GEa8g1F48rYXSZd361J+LtMK5zZEFEgk47u
	 53U8zRSiV2ZqVosD8hLi1CM0KojWSNdR1vz25nwkTygebGCTI+wrg18K+2uP+GImJZVcP
	 x7HFqZDd79SEoHIOe+/quuMC6YNO4hiE16WB05sEvwMCaU/jiS8bM4lgv4KEqqg1xcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795226631;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=o3eM6m0y8V1i+Z3N7EUTd+fkVFf9Z9Ku6000zDqRJSI=;
	b=cHTK+HaLdJ5aPOfKyzN3FdG0bhq4f7rlBGonHPQ7Im32Tj7+G52GNdg8TgGZKdsr17l5
	 4bhX2K8YlKODeRnh/9eV3EvuPwB9H5vT3rfxCzyA9XEe3a1qtyufVEG+062Wz0C+xHIgg
	 uTB/+Ej0YE1E07oL6rt1BbOF8P/XVooxyIpFA4e5jwDJ1wcGesRL/d5s20r6vsh/Znnd5
	 ULxfF3Od+4xw4P/5LZhzgUdrp+SKLSAwOXiUMEUg72D3OG/i+D5GyAlUJ1LsKnphVhF6M
	 /L81MFQ9jiENe5T2U1CyWjAWavsmPwPamB3RdS8OAq/bPEnLvu+rJR60jx4FMJssbSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=E5vm3rbA;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F133606A692;
	Sat, 21 Nov 2026 02:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F133606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=E5vm3rbA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795226623; x=1826762623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p84cDASYBpxUnT3Y5vUVuxAFFopmRAr7gDVSNHx9Ad0=;
  b=E5vm3rbA8PYngDjxMeD8aMfHdlaysmOs/t6VAv5askcNg1NfWf79VUDX
   fVQdKoU0ukCtXlBNVEKQlDzsXo+5GGGuTIQiEj1g2CKlRF70V24wx+FSB
   fQO7/rYMjDB+mfv/AoPIyv+7aTajxS/WKvrEpqOPyixm8dzakVHBXmWFh
   kkjb1s8GJrkHPgbHQ0in5ZAFjam8O9uA9ee+vhlxPdCWrVDL6ii2OUKXb
   YpTSH95294EkmaMLqzYQXsUqfgnFSF8RMANat6FrLLCnNRuzX79Fn3Zdj
   MAI23H2Sf6Ga2mQDtNd7/amEPhxict7KaapVzI9lSLO/WIWObfTeR51/3
   g==;
X-CSE-ConnectionGUID: QEGhq7V3SKi4q6jOc3dF+w==
X-CSE-MsgGUID: JczAJ/fXR8G39KBzro5DOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3996431"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="3996431"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 18:03:42 -0800
X-CSE-ConnectionGUID: ywjVGzMdTcaWGkeNBdvP2w==
X-CSE-MsgGUID: smj7LYleQnymwQOB1Y7wEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="11044575"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 20 Nov 2026 18:03:39 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUaS0-00000001JDt-1Atn;
	Sat, 21 Nov 2026 02:03:36 +0000
Date: Sat, 21 Nov 2026 10:03:01 +0800
From: kernel test robot <lkp@intel.com>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: hold back_lock across the copy of a
 Data-In
Message-ID: <202611210912.K4ornj7h-lkp@intel.com>
References: <20261120145243.3124991-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120145243.3124991-1-yhlee@isslab.korea.ac.kr>

Hi Yehyeong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linux-review/Yehyeong-Lee/scsi-libiscsi-only-complete-a-task-that-has-been-sent/20261117-191457]

url:    https://github.com/intel-lab-lkp/linux/commits/Yehyeong-Lee/scsi-libiscsi_tcp-hold-back_lock-across-the-copy-of-a-Data-In/20261120-235243
base:   https://github.com/intel-lab-lkp/linux Yehyeong-Lee/scsi-libiscsi-only-complete-a-task-that-has-been-sent/20261117-191457
patch link:    https://lore.kernel.org/r/20261120145243.3124991-1-yhlee%40isslab.korea.ac.kr
patch subject: [PATCH] scsi: libiscsi_tcp: hold back_lock across the copy of a Data-In
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20261121/202611210912.K4ornj7h-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 3b14d7c370558b46e5f0c6494a05c492e59bf32c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/202611210912.K4ornj7h-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611210912.K4ornj7h-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/libiscsi_tcp.c:960:6: warning: spinlock 'conn->session->back_lock' is not held on every path through here [-Wthread-safety-analysis]
     960 |         if (offloaded) {
         |             ^
   drivers/scsi/libiscsi_tcp.c:947:3: note: spinlock acquired here
     947 |                 spin_lock_bh(&session->back_lock);
         |                 ^
>> drivers/scsi/libiscsi_tcp.c:993:3: warning: releasing spinlock 'conn->session->back_lock' that was not held [-Wthread-safety-analysis]
     993 |                 spin_unlock_bh(&session->back_lock);
         |                 ^
   drivers/scsi/libiscsi_tcp.c:1009:3: warning: releasing spinlock 'conn->session->back_lock' that was not held [-Wthread-safety-analysis]
    1009 |                 spin_unlock_bh(&session->back_lock);
         |                 ^
   3 warnings generated.


vim +960 drivers/scsi/libiscsi_tcp.c

a081c13e39b5c1 Mike Christie 2008-12-02   903  
a081c13e39b5c1 Mike Christie 2008-12-02   904  /**
a081c13e39b5c1 Mike Christie 2008-12-02   905   * iscsi_tcp_recv_skb - Process skb
a081c13e39b5c1 Mike Christie 2008-12-02   906   * @conn: iscsi connection
a081c13e39b5c1 Mike Christie 2008-12-02   907   * @skb: network buffer with header and/or data segment
a081c13e39b5c1 Mike Christie 2008-12-02   908   * @offset: offset in skb
ccd4a43035090c Randy Dunlap  2017-12-22   909   * @offloaded: bool indicating if transfer was offloaded
ccd4a43035090c Randy Dunlap  2017-12-22   910   * @status: iscsi TCP status result
a081c13e39b5c1 Mike Christie 2008-12-02   911   *
ccd4a43035090c Randy Dunlap  2017-12-22   912   * Will return status of transfer in @status. And will return
a081c13e39b5c1 Mike Christie 2008-12-02   913   * number of bytes copied.
a081c13e39b5c1 Mike Christie 2008-12-02   914   */
a081c13e39b5c1 Mike Christie 2008-12-02   915  int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
a081c13e39b5c1 Mike Christie 2008-12-02   916  		       unsigned int offset, bool offloaded, int *status)
a081c13e39b5c1 Mike Christie 2008-12-02   917  {
a081c13e39b5c1 Mike Christie 2008-12-02   918  	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
a081c13e39b5c1 Mike Christie 2008-12-02   919  	struct iscsi_segment *segment = &tcp_conn->in.segment;
0d79b38099098f Yehyeong Lee  2026-11-20   920  	struct iscsi_session *session = conn->session;
a081c13e39b5c1 Mike Christie 2008-12-02   921  	struct skb_seq_state seq;
a081c13e39b5c1 Mike Christie 2008-12-02   922  	unsigned int consumed = 0;
0d79b38099098f Yehyeong Lee  2026-11-20   923  	bool copy_locked = false;
a081c13e39b5c1 Mike Christie 2008-12-02   924  	int rc = 0;
a081c13e39b5c1 Mike Christie 2008-12-02   925  
0ab1c2529e6a70 Mike Christie 2009-03-05   926  	ISCSI_DBG_TCP(conn, "in %d bytes\n", skb->len - offset);
d1acfae514425d Mike Christie 2009-05-13   927  	/*
d1acfae514425d Mike Christie 2009-05-13   928  	 * Update for each skb instead of pdu, because over slow networks a
d1acfae514425d Mike Christie 2009-05-13   929  	 * data_in's data could take a while to read in. We also want to
d1acfae514425d Mike Christie 2009-05-13   930  	 * account for r2ts.
d1acfae514425d Mike Christie 2009-05-13   931  	 */
d1acfae514425d Mike Christie 2009-05-13   932  	conn->last_recv = jiffies;
a081c13e39b5c1 Mike Christie 2008-12-02   933  
5bd856256f8c03 Mike Christie 2022-04-07   934  	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
0ab1c2529e6a70 Mike Christie 2009-03-05   935  		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
a081c13e39b5c1 Mike Christie 2008-12-02   936  		*status = ISCSI_TCP_SUSPENDED;
a081c13e39b5c1 Mike Christie 2008-12-02   937  		return 0;
a081c13e39b5c1 Mike Christie 2008-12-02   938  	}
a081c13e39b5c1 Mike Christie 2008-12-02   939  
0d79b38099098f Yehyeong Lee  2026-11-20   940  	/*
0d79b38099098f Yehyeong Lee  2026-11-20   941  	 * Hold back_lock across a Data-In copy so the command cannot be
0d79b38099098f Yehyeong Lee  2026-11-20   942  	 * given back while it runs.  _bh: this also runs from a work item.
0d79b38099098f Yehyeong Lee  2026-11-20   943  	 */
0d79b38099098f Yehyeong Lee  2026-11-20   944  	if (segment->sg) {
0d79b38099098f Yehyeong Lee  2026-11-20   945  		struct iscsi_task *task;
0d79b38099098f Yehyeong Lee  2026-11-20   946  
0d79b38099098f Yehyeong Lee  2026-11-20   947  		spin_lock_bh(&session->back_lock);
0d79b38099098f Yehyeong Lee  2026-11-20   948  		task = tcp_conn->in.datain_task;
0d79b38099098f Yehyeong Lee  2026-11-20   949  		if (!task || task->state != ISCSI_TASK_RUNNING) {
0d79b38099098f Yehyeong Lee  2026-11-20   950  			spin_unlock_bh(&session->back_lock);
0d79b38099098f Yehyeong Lee  2026-11-20   951  			iscsi_conn_printk(KERN_ERR, conn,
0d79b38099098f Yehyeong Lee  2026-11-20   952  					  "Data-In for a command that is gone\n");
0d79b38099098f Yehyeong Lee  2026-11-20   953  			*status = ISCSI_TCP_CONN_ERR;
0d79b38099098f Yehyeong Lee  2026-11-20   954  			iscsi_conn_failure(conn, ISCSI_ERR_BAD_ITT);
0d79b38099098f Yehyeong Lee  2026-11-20   955  			return 0;
0d79b38099098f Yehyeong Lee  2026-11-20   956  		}
0d79b38099098f Yehyeong Lee  2026-11-20   957  		copy_locked = true;
0d79b38099098f Yehyeong Lee  2026-11-20   958  	}
0d79b38099098f Yehyeong Lee  2026-11-20   959  
a081c13e39b5c1 Mike Christie 2008-12-02  @960  	if (offloaded) {
a081c13e39b5c1 Mike Christie 2008-12-02   961  		segment->total_copied = segment->total_size;
a081c13e39b5c1 Mike Christie 2008-12-02   962  		goto segment_done;
a081c13e39b5c1 Mike Christie 2008-12-02   963  	}
a081c13e39b5c1 Mike Christie 2008-12-02   964  
a081c13e39b5c1 Mike Christie 2008-12-02   965  	skb_prepare_seq_read(skb, offset, skb->len, &seq);
a081c13e39b5c1 Mike Christie 2008-12-02   966  	while (1) {
a081c13e39b5c1 Mike Christie 2008-12-02   967  		unsigned int avail;
a081c13e39b5c1 Mike Christie 2008-12-02   968  		const u8 *ptr;
a081c13e39b5c1 Mike Christie 2008-12-02   969  
a081c13e39b5c1 Mike Christie 2008-12-02   970  		avail = skb_seq_read(consumed, &ptr, &seq);
a081c13e39b5c1 Mike Christie 2008-12-02   971  		if (avail == 0) {
0ab1c2529e6a70 Mike Christie 2009-03-05   972  			ISCSI_DBG_TCP(conn, "no more data avail. Consumed %d\n",
a081c13e39b5c1 Mike Christie 2008-12-02   973  				      consumed);
a081c13e39b5c1 Mike Christie 2008-12-02   974  			*status = ISCSI_TCP_SKB_DONE;
a081c13e39b5c1 Mike Christie 2008-12-02   975  			goto skb_done;
a081c13e39b5c1 Mike Christie 2008-12-02   976  		}
a081c13e39b5c1 Mike Christie 2008-12-02   977  		BUG_ON(segment->copied >= segment->size);
a081c13e39b5c1 Mike Christie 2008-12-02   978  
0ab1c2529e6a70 Mike Christie 2009-03-05   979  		ISCSI_DBG_TCP(conn, "skb %p ptr=%p avail=%u\n", skb, ptr,
0ab1c2529e6a70 Mike Christie 2009-03-05   980  			      avail);
a081c13e39b5c1 Mike Christie 2008-12-02   981  		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
a081c13e39b5c1 Mike Christie 2008-12-02   982  		BUG_ON(rc == 0);
a081c13e39b5c1 Mike Christie 2008-12-02   983  		consumed += rc;
a081c13e39b5c1 Mike Christie 2008-12-02   984  
a081c13e39b5c1 Mike Christie 2008-12-02   985  		if (segment->total_copied >= segment->total_size) {
a081c13e39b5c1 Mike Christie 2008-12-02   986  			skb_abort_seq_read(&seq);
a081c13e39b5c1 Mike Christie 2008-12-02   987  			goto segment_done;
a081c13e39b5c1 Mike Christie 2008-12-02   988  		}
a081c13e39b5c1 Mike Christie 2008-12-02   989  	}
a081c13e39b5c1 Mike Christie 2008-12-02   990  
a081c13e39b5c1 Mike Christie 2008-12-02   991  segment_done:
0d79b38099098f Yehyeong Lee  2026-11-20   992  	if (copy_locked) {
0d79b38099098f Yehyeong Lee  2026-11-20  @993  		spin_unlock_bh(&session->back_lock);
0d79b38099098f Yehyeong Lee  2026-11-20   994  		copy_locked = false;
0d79b38099098f Yehyeong Lee  2026-11-20   995  	}
a081c13e39b5c1 Mike Christie 2008-12-02   996  	*status = ISCSI_TCP_SEGMENT_DONE;
0ab1c2529e6a70 Mike Christie 2009-03-05   997  	ISCSI_DBG_TCP(conn, "segment done\n");
a081c13e39b5c1 Mike Christie 2008-12-02   998  	rc = segment->done(tcp_conn, segment);
a081c13e39b5c1 Mike Christie 2008-12-02   999  	if (rc != 0) {
a081c13e39b5c1 Mike Christie 2008-12-02  1000  		*status = ISCSI_TCP_CONN_ERR;
0ab1c2529e6a70 Mike Christie 2009-03-05  1001  		ISCSI_DBG_TCP(conn, "Error receiving PDU, errno=%d\n", rc);
a081c13e39b5c1 Mike Christie 2008-12-02  1002  		iscsi_conn_failure(conn, rc);
a081c13e39b5c1 Mike Christie 2008-12-02  1003  		return 0;
a081c13e39b5c1 Mike Christie 2008-12-02  1004  	}
a081c13e39b5c1 Mike Christie 2008-12-02  1005  	/* The done() functions sets up the next segment. */
a081c13e39b5c1 Mike Christie 2008-12-02  1006  
a081c13e39b5c1 Mike Christie 2008-12-02  1007  skb_done:
0d79b38099098f Yehyeong Lee  2026-11-20  1008  	if (copy_locked)
0d79b38099098f Yehyeong Lee  2026-11-20  1009  		spin_unlock_bh(&session->back_lock);
a081c13e39b5c1 Mike Christie 2008-12-02  1010  	conn->rxdata_octets += consumed;
a081c13e39b5c1 Mike Christie 2008-12-02  1011  	return consumed;
a081c13e39b5c1 Mike Christie 2008-12-02  1012  }
a081c13e39b5c1 Mike Christie 2008-12-02  1013  EXPORT_SYMBOL_GPL(iscsi_tcp_recv_skb);
a081c13e39b5c1 Mike Christie 2008-12-02  1014  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794264637;
	b=iY8dfLajfpVrig4eRHk1UMfln5EagGk8dogPoYXBsM+1ck8usXd5yrapQOCaqcHMJECq
	 iLqCSmVoqPmXK10j4Y9GmzeHIo339LCyx1ZJn1mtF6HOz4DobEwhpu29NQED/QI4qXp1n
	 U9j22eY0tCDCWAu8wt6H+ExXzQPKQTYEPSqwRucDyDwqUeTk5boAoFR4K7vtYGBRzgIHk
	 jcd5kM5+b8zV755ZozME0NmWnhCt9w2F7vNUg46ZqdsaOLuz+usldkhBbbF9ROJUz/Vop
	 MACIra6oAxvsCN6rLdEG1JOKxJuE0XZt2E9pRHd56EQ3E1o9Tij7dLXrZWZTOZ7LJxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794264637;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=SwWS0eZdIXdUK1uTO+uVDmraMNMmJaKG736k5gmUwtc=;
	b=fLCvLh8KfalbXJjz2mhJ4Q6WbIx9oyTQ3H65XpYcsNE0/sxOzYOIP9Ad5dwh1ZTlN26d
	 cenUsbc5J/qjYzd31Qi70aXakaf/Nk+XTR2ZRndhc+8sfUQyJX5GYb3bqVm7PQNcwyKsD
	 w9IVaULO2moLaX/cbMGtO62LiuQ65HaoTwIXIR7L9mFWj1hGDKpye1QDPmwP5dPBA5xuM
	 uCa47LpCDR/qgfABB+R5RnAzOZcM7Grd8mDByBOZ1REWhNuZ8mKy4kXSzOWKiG0+eqyhL
	 Qk4iTEFJLIWAObkxoqNsnq5x0WUHdvEqWNo4U9QgXcwItvEEDBBetRKrqpDYlz3oKeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T7Ks1coY;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A3E606A31C;
	Mon,  9 Nov 2026 22:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0A3E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T7Ks1coY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794264636; x=1825800636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=u1dBGJ1G/PX1r4fCBcZn5nfQWlbbjKRuj9l+gMhFhqc=;
  b=T7Ks1coY9WNSsWPYxvdF3BZGYwPz8kU6qnUgkZnw1wtNg/zmkKsS5mZ2
   444gGnwtM/b9/pHahESsmITC62yCAcpiZHkht7M+7A2oDz+3cVBYh/YJz
   gTPkfF6euLtI/bWAJaZVb5OiM5X8X202m65xe8OcQ2ucjKcPHOS9CiNQ9
   KdYJNke81c+wm02y8qJgCEYAQxWPdM7YzVhLGCjnek4lRaFSpqA2tAfUX
   Gb3Khmh9itBvvaCrA8FP+6EOtEfKqDzG/rjCEB3iVYcs2knr8vOO6yMx5
   bBh8LkKYWqcrTdpAoCqLX6CMDnQON4hBIwHVKDHoSw4Ce9RAmGMm5v0Tv
   Q==;
X-CSE-ConnectionGUID: CnsjHynfT3mT4QuoGHATFg==
X-CSE-MsgGUID: t2QaD2+vSz+RjoX/gTQlYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2899161"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2899161"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 14:50:35 -0800
X-CSE-ConnectionGUID: h+ESVRPhRN6PE1B+o1Vusg==
X-CSE-MsgGUID: hrIGUffwSOeAiAeq+aTOKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="7798859"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 09 Nov 2026 14:50:32 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQYC6-00000000vUR-1xFV;
	Mon, 09 Nov 2026 22:50:30 +0000
Date: Tue, 10 Nov 2026 06:50:02 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Adri=E1n_Garc=EDa?= Casado <adriangarciacasado42@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	GR-ETH-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Adri=E1n_Garc=EDa?= Casado <adriangarciacasado42@gmail.com>
Subject: Re: [PATCH] scsi: qedi: Add __printf to debug helpers and fix format
 strings
Message-ID: <202611100645.IuoveOp3-lkp@intel.com>
References: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>

Hi Adrián,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.4-rc2 next-20261109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Adri-n-Garc-a-Casado/scsi-qedi-Add-__printf-to-debug-helpers-and-fix-format-strings/20261109-151738
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20261109141738.1624579-1-adriangarciacasado42%40gmail.com
patch subject: [PATCH] scsi: qedi: Add __printf to debug helpers and fix format strings
config: i386-randconfig-1002-20261109 (https://download.01.org/0day-ci/archive/20261110/202611100645.IuoveOp3-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261110/202611100645.IuoveOp3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611100645.IuoveOp3-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/qedi/qedi_main.c:1489:5: warning: format specifies type 'unsigned long long' but the argument has type 'dma_addr_t' (aka 'unsigned int') [-Wformat]
    1488 |                   "NVM BUF addr=0x%p dma=0x%llx.\n", qedi->iscsi_image,
         |                                            ~~~~
         |                                            %x
    1489 |                   qedi->nvm_buf_dma);
         |                   ^~~~~~~~~~~~~~~~~
   drivers/scsi/qedi/qedi_dbg.h:79:13: note: expanded from macro 'QEDI_INFO'
      78 |                 qedi_dbg_info(pdev, __func__, __LINE__, level, fmt,     \
         |                                                                ~~~
      79 |                               ## __VA_ARGS__)
         |                                  ^~~~~~~~~~~
   1 warning generated.


vim +1489 drivers/scsi/qedi/qedi_main.c

c57ec8fb7c0253 Nilesh Javali    2017-06-27  1477  
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1478  static int qedi_alloc_nvm_iscsi_cfg(struct qedi_ctx *qedi)
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1479  {
750afb08ca7131 Luis Chamberlain 2019-01-04  1480  	qedi->iscsi_image = dma_alloc_coherent(&qedi->pdev->dev,
872e192fab6438 Colin Ian King   2019-03-27  1481  					       sizeof(struct qedi_nvm_iscsi_image),
750afb08ca7131 Luis Chamberlain 2019-01-04  1482  					       &qedi->nvm_buf_dma, GFP_KERNEL);
c77a2fa3ff8f73 Nilesh Javali    2018-08-29  1483  	if (!qedi->iscsi_image) {
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1484  		QEDI_ERR(&qedi->dbg_ctx, "Could not allocate NVM BUF.\n");
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1485  		return -ENOMEM;
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1486  	}
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1487  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
c77a2fa3ff8f73 Nilesh Javali    2018-08-29  1488  		  "NVM BUF addr=0x%p dma=0x%llx.\n", qedi->iscsi_image,
c57ec8fb7c0253 Nilesh Javali    2017-06-27 @1489  		  qedi->nvm_buf_dma);
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1490  
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1491  	return 0;
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1492  }
c57ec8fb7c0253 Nilesh Javali    2017-06-27  1493  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

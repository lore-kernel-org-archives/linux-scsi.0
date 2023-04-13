Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F30C77B6C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 02:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjDMCLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 22:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMCLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 22:11:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7BD4C3D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 19:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681351894; x=1712887894;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p8khjdCueTmVTKRByYWtpp4+ehRClpDkQhus6WNDsMk=;
  b=UXh+ZqeIYJ/LMMQraN3dyS1XBaIVfch6UtXv3uKDX1oTOa7Ym0PzCFPW
   QBjJqLF399ZmhWN2A602XJKnlv75ZXvpEgamIw4rGmYT5CfXpUBFlLx/D
   u4poMmknn5ONKZxTKjL9m8dvGTxSqR3vo9PrQLMnmTu24chHxDGRm6pm3
   z4iyDXlYqN5qaxqVYeHitDXlRQuwx2u6/xq8VoEEW8R9HCiufslItfh1r
   BhuXYrF2G+Qq7oqSC2ZohA9oaRpC3Npr1ifgG9O7JYrn8zDWHACY7m4/j
   AG4gbq878QFX6Iks3mdk4jSbewHhQrBEUWvvU+ZCGEbpmXkya3F039Yk0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409216212"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409216212"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 19:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="813205613"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="813205613"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 12 Apr 2023 19:11:31 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pmmQs-000YFZ-2n;
        Thu, 13 Apr 2023 02:11:30 +0000
Date:   Thu, 13 Apr 2023 10:11:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Brian King <brking@linux.vnet.ibm.com>, martin.petersen@oracle.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com,
        wenxiong@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: Remove SATA support
Message-ID: <202304131029.cr0XqKeg-lkp@intel.com>
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Brian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.3-rc6 next-20230412]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Brian-King/ipr-Remove-SATA-support/20230413-014213
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230412174015.114764-1-brking%40linux.vnet.ibm.com
patch subject: [PATCH] ipr: Remove SATA support
config: x86_64-randconfig-a001-20230410 (https://download.01.org/0day-ci/archive/20230413/202304131029.cr0XqKeg-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3562ad7d350c7c5b3f13508ef3323b1239de71e2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Brian-King/ipr-Remove-SATA-support/20230413-014213
        git checkout 3562ad7d350c7c5b3f13508ef3323b1239de71e2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304131029.cr0XqKeg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/ipr.c:1104:15: warning: variable 'proto' set but not used [-Wunused-but-set-variable]
           unsigned int proto;
                        ^
   drivers/scsi/ipr.c:1261:15: warning: variable 'proto' set but not used [-Wunused-but-set-variable]
           unsigned int proto;
                        ^
>> drivers/scsi/ipr.c:4417:29: warning: variable 'res' set but not used [-Wunused-but-set-variable]
           struct ipr_resource_entry *res;
                                      ^
   drivers/scsi/ipr.c:5430:6: warning: variable 'ioasc' set but not used [-Wunused-but-set-variable]
           u32 ioasc;
               ^
   4 warnings generated.


vim +/proto +1104 drivers/scsi/ipr.c

^1da177e4c3f415 Linus Torvalds 2005-04-16  1091  
^1da177e4c3f415 Linus Torvalds 2005-04-16  1092  /**
^1da177e4c3f415 Linus Torvalds 2005-04-16  1093   * ipr_init_res_entry - Initialize a resource entry struct.
^1da177e4c3f415 Linus Torvalds 2005-04-16  1094   * @res:	resource entry struct
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1095   * @cfgtew:	config table entry wrapper struct
^1da177e4c3f415 Linus Torvalds 2005-04-16  1096   *
^1da177e4c3f415 Linus Torvalds 2005-04-16  1097   * Return value:
^1da177e4c3f415 Linus Torvalds 2005-04-16  1098   * 	none
^1da177e4c3f415 Linus Torvalds 2005-04-16  1099   **/
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1100  static void ipr_init_res_entry(struct ipr_resource_entry *res,
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1101  			       struct ipr_config_table_entry_wrapper *cfgtew)
^1da177e4c3f415 Linus Torvalds 2005-04-16  1102  {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1103  	int found = 0;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19 @1104  	unsigned int proto;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1105  	struct ipr_ioa_cfg *ioa_cfg = res->ioa_cfg;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1106  	struct ipr_resource_entry *gscsi_res = NULL;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1107  
ee0a90fa3efffca Brian King     2005-11-01  1108  	res->needs_sync_complete = 0;
^1da177e4c3f415 Linus Torvalds 2005-04-16  1109  	res->in_erp = 0;
^1da177e4c3f415 Linus Torvalds 2005-04-16  1110  	res->add_to_ml = 0;
^1da177e4c3f415 Linus Torvalds 2005-04-16  1111  	res->del_from_ml = 0;
^1da177e4c3f415 Linus Torvalds 2005-04-16  1112  	res->resetting_device = 0;
0b1f8d445b8cc5a Wendy Xiong    2014-01-21  1113  	res->reset_occurred = 0;
^1da177e4c3f415 Linus Torvalds 2005-04-16  1114  	res->sdev = NULL;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1115  
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1116  	if (ioa_cfg->sis64) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1117  		proto = cfgtew->u.cfgte64->proto;
359d96e73cea0ef Brian King     2015-06-11  1118  		res->flags = be16_to_cpu(cfgtew->u.cfgte64->flags);
359d96e73cea0ef Brian King     2015-06-11  1119  		res->res_flags = be16_to_cpu(cfgtew->u.cfgte64->res_flags);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1120  		res->qmodel = IPR_QUEUEING_MODEL64(res);
438b03311108b05 Wayne Boyer    2010-05-10  1121  		res->type = cfgtew->u.cfgte64->res_type;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1122  
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1123  		memcpy(res->res_path, &cfgtew->u.cfgte64->res_path,
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1124  			sizeof(res->res_path));
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1125  
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1126  		res->bus = 0;
0cb992eda1f7e76 Wayne Boyer    2010-11-04  1127  		memcpy(&res->dev_lun.scsi_lun, &cfgtew->u.cfgte64->lun,
0cb992eda1f7e76 Wayne Boyer    2010-11-04  1128  			sizeof(res->dev_lun.scsi_lun));
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1129  		res->lun = scsilun_to_int(&res->dev_lun);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1130  
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1131  		if (res->type == IPR_RES_TYPE_GENERIC_SCSI) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1132  			list_for_each_entry(gscsi_res, &ioa_cfg->used_res_q, queue) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1133  				if (gscsi_res->dev_id == cfgtew->u.cfgte64->dev_id) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1134  					found = 1;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1135  					res->target = gscsi_res->target;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1136  					break;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1137  				}
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1138  			}
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1139  			if (!found) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1140  				res->target = find_first_zero_bit(ioa_cfg->target_ids,
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1141  								  ioa_cfg->max_devs_supported);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1142  				set_bit(res->target, ioa_cfg->target_ids);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1143  			}
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1144  		} else if (res->type == IPR_RES_TYPE_IOAFP) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1145  			res->bus = IPR_IOAFP_VIRTUAL_BUS;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1146  			res->target = 0;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1147  		} else if (res->type == IPR_RES_TYPE_ARRAY) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1148  			res->bus = IPR_ARRAY_VIRTUAL_BUS;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1149  			res->target = find_first_zero_bit(ioa_cfg->array_ids,
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1150  							  ioa_cfg->max_devs_supported);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1151  			set_bit(res->target, ioa_cfg->array_ids);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1152  		} else if (res->type == IPR_RES_TYPE_VOLUME_SET) {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1153  			res->bus = IPR_VSET_VIRTUAL_BUS;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1154  			res->target = find_first_zero_bit(ioa_cfg->vset_ids,
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1155  							  ioa_cfg->max_devs_supported);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1156  			set_bit(res->target, ioa_cfg->vset_ids);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1157  		} else {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1158  			res->target = find_first_zero_bit(ioa_cfg->target_ids,
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1159  							  ioa_cfg->max_devs_supported);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1160  			set_bit(res->target, ioa_cfg->target_ids);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1161  		}
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1162  	} else {
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1163  		proto = cfgtew->u.cfgte->proto;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1164  		res->qmodel = IPR_QUEUEING_MODEL(res);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1165  		res->flags = cfgtew->u.cfgte->flags;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1166  		if (res->flags & IPR_IS_IOA_RESOURCE)
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1167  			res->type = IPR_RES_TYPE_IOAFP;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1168  		else
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1169  			res->type = cfgtew->u.cfgte->rsvd_subtype & 0x0f;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1170  
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1171  		res->bus = cfgtew->u.cfgte->res_addr.bus;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1172  		res->target = cfgtew->u.cfgte->res_addr.target;
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1173  		res->lun = cfgtew->u.cfgte->res_addr.lun;
46d7456324766cd Wayne Boyer    2010-08-11  1174  		res->lun_wwn = get_unaligned_be64(cfgtew->u.cfgte->lun_wwn);
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1175  	}
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1176  }
3e7ebdfa58ddaef Wayne Boyer    2010-02-19  1177  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

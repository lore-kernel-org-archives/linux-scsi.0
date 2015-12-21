From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 3/3] hpsa: add box and bay information for enclosure
 devices
Date: Tue, 22 Dec 2015 01:47:48 +0800
Message-ID: <201512220129.CV5tgYsh%fengguang.wu@intel.com>
References: <20151221172146.14423.43517.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbbLURpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2015 12:45:51 -0500
Content-Disposition: inline
In-Reply-To: <20151221172146.14423.43517.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: kbuild-all@01.org, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com, linux-scsi@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Don,

[auto build test ERROR on scsi/for-next]
[also build test ERROR on v4.4-rc6 next-20151221]

url:    https://github.com/0day-ci/linux/commits/Don-Brace/hpsa-updates/20151222-012604
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: i386-randconfig-x005-201551 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   drivers/scsi/hpsa.c: In function 'hpsa_get_enclosure_info':
   drivers/scsi/hpsa.c:3201:2: error: parameter 'rc' is initialized
     int rc = -1;
     ^
   drivers/scsi/hpsa.c:3202:9: error: parameter 'c' is initialized
     struct CommandList *c = NULL;
            ^
   drivers/scsi/hpsa.c:3203:9: error: parameter 'ei' is initialized
     struct ErrorInfo *ei = NULL;
            ^
   drivers/scsi/hpsa.c:3204:9: error: parameter 'bssbp' is initialized
     struct bmic_sense_storage_box_params *bssbp = NULL;
            ^
   drivers/scsi/hpsa.c:3205:9: error: parameter 'id_phys' is initialized
     struct bmic_identify_physical_device *id_phys = NULL;
            ^
   drivers/scsi/hpsa.c:3206:9: error: parameter 'rle' is initialized
     struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
            ^
   drivers/scsi/hpsa.c:3206:38: error: 'rlep' undeclared (first use in this function)
     struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
                                         ^
   drivers/scsi/hpsa.c:3206:38: note: each undeclared identifier is reported only once for each function it appears in
   drivers/scsi/hpsa.c:3206:48: error: 'rle_index' undeclared (first use in this function)
     struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
                                                   ^
   drivers/scsi/hpsa.c:3207:2: error: parameter 'bmic_device_index' is initialized
     u16 bmic_device_index = 0;
     ^
   drivers/scsi/hpsa.c:3209:2: error: expected declaration specifiers before 'bmic_device_index'
     bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
>> drivers/scsi/hpsa.c:3211:2: note: in expansion of macro 'if'
     if (bmic_device_index == 0xFF00)
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
>> drivers/scsi/hpsa.c:3211:2: note: in expansion of macro 'if'
     if (bmic_device_index == 0xFF00)
     ^
   drivers/scsi/hpsa.c:3214:2: error: expected declaration specifiers before 'bssbp'
     bssbp = kzalloc(sizeof(*bssbp), GFP_KERNEL);
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3215:2: note: in expansion of macro 'if'
     if (!bssbp)
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3215:2: note: in expansion of macro 'if'
     if (!bssbp)
     ^
   drivers/scsi/hpsa.c:3218:2: error: expected declaration specifiers before 'id_phys'
     id_phys = kzalloc(sizeof(*id_phys), GFP_KERNEL);
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3219:2: note: in expansion of macro 'if'
     if (!id_phys)
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3219:2: note: in expansion of macro 'if'
     if (!id_phys)
     ^
   drivers/scsi/hpsa.c:3222:2: error: expected declaration specifiers before 'rc'
     rc = hpsa_bmic_id_physical_device(h, scsi3addr, bmic_device_index,
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3224:2: note: in expansion of macro 'if'
     if (rc) {
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3224:2: note: in expansion of macro 'if'
     if (rc) {
     ^
   drivers/scsi/hpsa.c:3230:2: error: expected declaration specifiers before 'c'
     c = cmd_alloc(h);
     ^
   drivers/scsi/hpsa.c:3232:2: error: expected declaration specifiers before 'rc'
     rc = fill_cmd(c, BMIC_SENSE_STORAGE_BOX_PARAMS, h, bssbp,
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3235:2: note: in expansion of macro 'if'
     if (rc)
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3235:2: note: in expansion of macro 'if'
     if (rc)
     ^
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3238:2: note: in expansion of macro 'if'
     if (id_phys->phys_connector[1] == 'E')
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3238:2: note: in expansion of macro 'if'
     if (id_phys->phys_connector[1] == 'E')
     ^
   drivers/scsi/hpsa.c:3240:2: error: expected declaration specifiers before 'else'
     else
     ^
   drivers/scsi/hpsa.c:3243:2: error: expected declaration specifiers before 'rc'
     rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3245:2: note: in expansion of macro 'if'
     if (rc)
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3245:2: note: in expansion of macro 'if'
     if (rc)
     ^
   drivers/scsi/hpsa.c:3248:2: error: expected declaration specifiers before 'ei'
     ei = c->err_info;
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> include/linux/compiler.h:147:2: error: expected declaration specifiers before 'if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
     ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3249:2: note: in expansion of macro 'if'
     if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
     ^
>> include/linux/compiler.h:161:3: error: expected declaration specifiers before ')' token
     }))
      ^
   include/linux/compiler.h:145:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^
   drivers/scsi/hpsa.c:3249:2: note: in expansion of macro 'if'
     if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
     ^
   drivers/scsi/hpsa.c:3254:2: error: expected declaration specifiers before 'encl_dev'
     encl_dev->box[id_phys->active_path_number] = bssbp->phys_box_on_port;
     ^
   In file included from arch/x86/include/asm/string.h:2:0,
                    from include/linux/string.h:17,
                    from include/linux/dynamic_debug.h:111,
                    from include/linux/printk.h:277,
                    from include/linux/kernel.h:13,
                    from include/linux/list.h:8,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:
>> arch/x86/include/asm/string_32.h:182:25: error: expected declaration specifiers before '__builtin_memcpy'
    #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
                            ^
>> drivers/scsi/hpsa.c:3255:2: note: in expansion of macro 'memcpy'
     memcpy(&encl_dev->phys_connector[id_phys->active_path_number],
     ^
   drivers/scsi/hpsa.c:3258:2: error: expected declaration specifiers before 'rc'
     rc = IO_OK;
     ^
   drivers/scsi/hpsa.c:3259:1: error: expected declaration specifiers before 'out'
    out:
    ^
   drivers/scsi/hpsa.c:3261:2: error: expected declaration specifiers before 'kfree'
     kfree(id_phys);
     ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/scsi/hpsa.c:19:

vim +/if +3211 drivers/scsi/hpsa.c

  3205		struct bmic_identify_physical_device *id_phys = NULL;
  3206		struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
  3207		u16 bmic_device_index = 0;
  3208	
  3209		bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
  3210	
> 3211		if (bmic_device_index == 0xFF00)
  3212			goto out;
  3213	
  3214		bssbp = kzalloc(sizeof(*bssbp), GFP_KERNEL);
  3215		if (!bssbp)
  3216			goto out;
  3217	
  3218		id_phys = kzalloc(sizeof(*id_phys), GFP_KERNEL);
  3219		if (!id_phys)
  3220			goto out;
  3221	
  3222		rc = hpsa_bmic_id_physical_device(h, scsi3addr, bmic_device_index,
  3223							id_phys, sizeof(*id_phys));
  3224		if (rc) {
  3225			dev_warn(&h->pdev->dev, "%s: id_phys failed %d bdi[0x%x]\n",
  3226				__func__, encl_dev->external, bmic_device_index);
  3227			goto out;
  3228		}
  3229	
  3230		c = cmd_alloc(h);
  3231	
  3232		rc = fill_cmd(c, BMIC_SENSE_STORAGE_BOX_PARAMS, h, bssbp,
  3233				sizeof(*bssbp), 0, RAID_CTLR_LUNID, TYPE_CMD);
  3234	
  3235		if (rc)
  3236			goto out;
  3237	
  3238		if (id_phys->phys_connector[1] == 'E')
  3239			c->Request.CDB[5] = id_phys->box_index;
  3240		else
  3241			c->Request.CDB[5] = 0;
  3242	
  3243		rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
  3244							NO_TIMEOUT);
  3245		if (rc)
  3246			goto out;
  3247	
  3248		ei = c->err_info;
  3249		if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
  3250			rc = -1;
  3251			goto out;
  3252		}
  3253	
  3254		encl_dev->box[id_phys->active_path_number] = bssbp->phys_box_on_port;
> 3255		memcpy(&encl_dev->phys_connector[id_phys->active_path_number],
  3256			bssbp->phys_connector, sizeof(bssbp->phys_connector));
  3257	
  3258		rc = IO_OK;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--oyUTqETQ0mS9luUI
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--oyUTqETQ0mS9luUI--

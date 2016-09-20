From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 8/9] sd: Implement support for ZBC devices
Date: Tue, 20 Sep 2016 08:08:25 +0800
Message-ID: <201609200803.XFmKiZm3%fengguang.wu@intel.com>
References: <1474320454-5264-9-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31775 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751648AbcITAIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Sep 2016 20:08:49 -0400
Content-Disposition: inline
In-Reply-To: <1474320454-5264-9-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@hgst.com>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hannes,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.8-rc7]
[cannot apply to block/for-next next-20160919]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Damien-Le-Moal/ZBC-Zoned-block-device-support/20160920-062608
config: i386-allmodconfig (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:13:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_report_zones':
>> drivers/scsi/sd_zbc.c:61:11: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
     pr_debug("%s %s [%s]: " fmt,    \
              ^
   include/linux/printk.h:260:21: note: in definition of macro 'pr_fmt'
    #define pr_fmt(fmt) fmt
                        ^~~
   include/linux/printk.h:308:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^~~~~~~~~~~~~~~~
>> drivers/scsi/sd_zbc.c:61:2: note: in expansion of macro 'pr_debug'
     pr_debug("%s %s [%s]: " fmt,    \
     ^~~~~~~~
>> drivers/scsi/sd_zbc.c:221:2: note: in expansion of macro 'sd_zbc_debug'
     sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n",
     ^~~~~~~~~~~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:13,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
>> include/linux/kern_levels.h:4:18: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:10:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:276:9: note: in expansion of macro 'KERN_ERR'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~
>> drivers/scsi/sd_zbc.c:73:2: note: in expansion of macro 'pr_err'
     pr_err("%s %s [%s]: " fmt,    \
     ^~~~~~
>> drivers/scsi/sd_zbc.c:237:3: note: in expansion of macro 'sd_zbc_err'
      sd_zbc_err(sdkp,
      ^~~~~~~~~~
   In file included from include/linux/kernel.h:13:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_setup_reset_cmnd':
>> drivers/scsi/sd_zbc.c:61:11: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
     pr_debug("%s %s [%s]: " fmt,    \
              ^
   include/linux/printk.h:260:21: note: in definition of macro 'pr_fmt'
    #define pr_fmt(fmt) fmt
                        ^~~
   include/linux/printk.h:308:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^~~~~~~~~~~~~~~~
>> drivers/scsi/sd_zbc.c:61:2: note: in expansion of macro 'pr_debug'
     pr_debug("%s %s [%s]: " fmt,    \
     ^~~~~~~~
   drivers/scsi/sd_zbc.c:489:4: note: in expansion of macro 'sd_zbc_debug'
       sd_zbc_debug(sdkp,
       ^~~~~~~~~~~~
   In file included from drivers/scsi/sd_zbc.c:37:0:
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   In file included from include/scsi/scsi_cmnd.h:10:0,
                    from drivers/scsi/sd_zbc.c:30:
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
>> drivers/scsi/sd_zbc.c:516:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
>> drivers/scsi/sd_zbc.c:516:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
>> drivers/scsi/sd_zbc.c:516:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:517:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned reset wp request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
>> drivers/scsi/sd_zbc.c:516:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   In file included from include/linux/kernel.h:13:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_setup_open_cmnd':
>> drivers/scsi/sd_zbc.c:61:11: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
     pr_debug("%s %s [%s]: " fmt,    \
              ^
   include/linux/printk.h:260:21: note: in definition of macro 'pr_fmt'
    #define pr_fmt(fmt) fmt
                        ^~~
   include/linux/printk.h:308:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^~~~~~~~~~~~~~~~
>> drivers/scsi/sd_zbc.c:61:2: note: in expansion of macro 'pr_debug'
     pr_debug("%s %s [%s]: " fmt,    \
     ^~~~~~~~
   drivers/scsi/sd_zbc.c:573:4: note: in expansion of macro 'sd_zbc_debug'
       sd_zbc_debug(sdkp,
       ^~~~~~~~~~~~
   In file included from drivers/scsi/sd_zbc.c:37:0:
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   In file included from include/scsi/scsi_cmnd.h:10:0,
                    from drivers/scsi/sd_zbc.c:30:
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:593:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:593:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:593:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:594:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned open zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:593:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   In file included from include/linux/kernel.h:13:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_setup_close_cmnd':
>> drivers/scsi/sd_zbc.c:61:11: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
     pr_debug("%s %s [%s]: " fmt,    \
              ^
   include/linux/printk.h:260:21: note: in definition of macro 'pr_fmt'
    #define pr_fmt(fmt) fmt
                        ^~~
   include/linux/printk.h:308:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^~~~~~~~~~~~~~~~
>> drivers/scsi/sd_zbc.c:61:2: note: in expansion of macro 'pr_debug'
     pr_debug("%s %s [%s]: " fmt,    \
     ^~~~~~~~
   drivers/scsi/sd_zbc.c:645:4: note: in expansion of macro 'sd_zbc_debug'
       sd_zbc_debug(sdkp,
       ^~~~~~~~~~~~
   In file included from drivers/scsi/sd_zbc.c:37:0:
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   In file included from include/scsi/scsi_cmnd.h:10:0,
                    from drivers/scsi/sd_zbc.c:30:
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:665:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:665:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:665:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:666:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned close zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:665:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   In file included from include/linux/kernel.h:13:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_setup_finish_cmnd':
>> drivers/scsi/sd_zbc.c:61:11: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
     pr_debug("%s %s [%s]: " fmt,    \
              ^
   include/linux/printk.h:260:21: note: in definition of macro 'pr_fmt'
    #define pr_fmt(fmt) fmt
                        ^~~
   include/linux/printk.h:308:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^~~~~~~~~~~~~~~~
>> drivers/scsi/sd_zbc.c:61:2: note: in expansion of macro 'pr_debug'
     pr_debug("%s %s [%s]: " fmt,    \
     ^~~~~~~~
   drivers/scsi/sd_zbc.c:717:4: note: in expansion of macro 'sd_zbc_debug'
       sd_zbc_debug(sdkp,
       ^~~~~~~~~~~~
   In file included from drivers/scsi/sd_zbc.c:37:0:
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~
   In file included from include/scsi/scsi_cmnd.h:10:0,
                    from drivers/scsi/sd_zbc.c:30:
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:733:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:733:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:733:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   drivers/scsi/sd_zbc.c:734:7: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
          "Unaligned finish zone request, start %zu/%zu"
          ^
   include/scsi/scsi_device.h:233:36: note: in definition of macro 'sdev_printk'
     sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
                                       ^~~
   drivers/scsi/sd_zbc.c:733:4: note: in expansion of macro 'sd_printk'
       sd_printk(KERN_ERR, sdkp,
       ^~~~~~~~~
   In file included from include/linux/kernel.h:13:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from drivers/scsi/sd_zbc.c:24:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_setup_read_write':
>> drivers/scsi/sd_zbc.c:61:11: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
     pr_debug("%s %s [%s]: " fmt,    \
              ^
   include/linux/printk.h:260:21: note: in definition of macro 'pr_fmt'
    #define pr_fmt(fmt) fmt
                        ^~~
   include/linux/printk.h:308:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^~~~~~~~~~~~~~~~
>> drivers/scsi/sd_zbc.c:61:2: note: in expansion of macro 'pr_debug'
     pr_debug("%s %s [%s]: " fmt,    \
     ^~~~~~~~
   drivers/scsi/sd_zbc.c:783:3: note: in expansion of macro 'sd_zbc_debug'
      sd_zbc_debug(sdkp,
      ^~~~~~~~~~~~
   In file included from drivers/scsi/sd_zbc.c:37:0:
   drivers/scsi/sd_zbc.c: In function 'sd_zbc_read_zones':
   drivers/scsi/sd_zbc.c:985:8: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
           "Changing capacity from %zu "
           ^
   drivers/scsi/sd.h:116:31: note: in definition of macro 'sd_printk'
         (sdsk)->disk->disk_name, fmt, ##a) : \
                                  ^~~

vim +61 drivers/scsi/sd_zbc.c

    18	 * along with this program; see the file COPYING.  If not, write to
    19	 * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
    20	 * USA.
    21	 *
    22	 */
    23	
  > 24	#include <linux/blkdev.h>
    25	#include <linux/rbtree.h>
    26	
    27	#include <asm/unaligned.h>
    28	
    29	#include <scsi/scsi.h>
  > 30	#include <scsi/scsi_cmnd.h>
    31	#include <scsi/scsi_dbg.h>
    32	#include <scsi/scsi_device.h>
    33	#include <scsi/scsi_driver.h>
    34	#include <scsi/scsi_host.h>
    35	#include <scsi/scsi_eh.h>
    36	
  > 37	#include "sd.h"
    38	#include "scsi_priv.h"
    39	
    40	enum zbc_zone_type {
    41		ZBC_ZONE_TYPE_CONV = 0x1,
    42		ZBC_ZONE_TYPE_SEQWRITE_REQ,
    43		ZBC_ZONE_TYPE_SEQWRITE_PREF,
    44		ZBC_ZONE_TYPE_RESERVED,
    45	};
    46	
    47	enum zbc_zone_cond {
    48		ZBC_ZONE_COND_NO_WP,
    49		ZBC_ZONE_COND_EMPTY,
    50		ZBC_ZONE_COND_IMP_OPEN,
    51		ZBC_ZONE_COND_EXP_OPEN,
    52		ZBC_ZONE_COND_CLOSED,
    53		ZBC_ZONE_COND_READONLY = 0xd,
    54		ZBC_ZONE_COND_FULL,
    55		ZBC_ZONE_COND_OFFLINE,
    56	};
    57	
    58	#define SD_ZBC_BUF_SIZE 131072
    59	
    60	#define sd_zbc_debug(sdkp, fmt, args...)			\
  > 61		pr_debug("%s %s [%s]: " fmt,				\
    62			 dev_driver_string(&(sdkp)->device->sdev_gendev), \
    63			 dev_name(&(sdkp)->device->sdev_gendev),	 \
    64			 (sdkp)->disk->disk_name, ## args)
    65	
    66	#define sd_zbc_debug_ratelimit(sdkp, fmt, args...)		\
    67		do {							\
    68			if (printk_ratelimit())				\
    69				sd_zbc_debug(sdkp, fmt, ## args);	\
    70		} while( 0 )
    71	
    72	#define sd_zbc_err(sdkp, fmt, args...)				\
  > 73		pr_err("%s %s [%s]: " fmt,				\
    74		       dev_driver_string(&(sdkp)->device->sdev_gendev),	\
    75		       dev_name(&(sdkp)->device->sdev_gendev),		\
    76		       (sdkp)->disk->disk_name, ## args)
    77	
    78	struct zbc_zone_work {
    79		struct work_struct 	zone_work;
    80		struct scsi_disk 	*sdkp;
    81		sector_t		sector;
    82		sector_t		nr_sects;
    83		bool 			init;
    84		unsigned int		nr_zones;
    85	};
    86	
    87	struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
    88	{
    89		struct blk_zone *zone;
    90	
    91		zone = kzalloc(sizeof(struct blk_zone), GFP_KERNEL);
    92		if (!zone)
    93			return NULL;
    94	
    95		/* Zone type */
    96		switch(rec[0] & 0x0f) {
    97		case ZBC_ZONE_TYPE_CONV:
    98		case ZBC_ZONE_TYPE_SEQWRITE_REQ:
    99		case ZBC_ZONE_TYPE_SEQWRITE_PREF:
   100			zone->type = rec[0] & 0x0f;
   101			break;
   102		default:
   103			zone->type = BLK_ZONE_TYPE_UNKNOWN;
   104			break;
   105		}
   106	
   107		/* Zone condition */
   108		zone->cond = (rec[1] >> 4) & 0xf;
   109		if (rec[1] & 0x01)
   110			zone->reset = 1;
   111		if (rec[1] & 0x02)
   112			zone->non_seq = 1;
   113	
   114		/* Zone start sector and length */
   115		zone->len = logical_to_sectors(sdkp->device,
   116					       get_unaligned_be64(&rec[8]));
   117		zone->start = logical_to_sectors(sdkp->device,
   118						 get_unaligned_be64(&rec[16]));
   119	
   120		/* Zone write pointer */
   121		if (blk_zone_is_empty(zone) &&
   122		    zone->wp != zone->start)
   123			zone->wp = zone->start;
   124		else if (blk_zone_is_full(zone))
   125			zone->wp = zone->start + zone->len;
   126		else if (blk_zone_is_seq(zone))
   127			zone->wp = logical_to_sectors(sdkp->device,
   128						      get_unaligned_be64(&rec[24]));
   129		else
   130			zone->wp = (sector_t)-1;
   131	
   132		return zone;
   133	}
   134	
   135	static int zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
   136				   unsigned int buf_len, sector_t *next_sector)
   137	{
   138		struct request_queue *q = sdkp->disk->queue;
   139		sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
   140		unsigned char *rec = buf;
   141		unsigned int zone_len, list_length;
   142	
   143		/* Parse REPORT ZONES header */
   144		list_length = get_unaligned_be32(&buf[0]);
   145		rec = buf + 64;
   146		list_length += 64;
   147	
   148		if (list_length < buf_len)
   149			buf_len = list_length;
   150	
   151		/* Parse REPORT ZONES zone descriptors */
   152		*next_sector = capacity;
   153		while (rec < buf + buf_len) {
   154	
   155			struct blk_zone *new, *old;
   156	
   157			new = zbc_desc_to_zone(sdkp, rec);
   158			if (!new)
   159				return -ENOMEM;
   160	
   161			zone_len = new->len;
   162			*next_sector = new->start + zone_len;
   163	
   164			old = blk_insert_zone(q, new);
   165			if (old) {
   166				blk_lock_zone(old);
   167	
   168				/*
   169				 * Always update the zone state flags and the zone
   170				 * offline and read-only condition as the drive may
   171				 * change those independently of the commands being
   172				 * executed
   173				 */
   174				old->reset = new->reset;
   175				old->non_seq = new->non_seq;
   176				if (blk_zone_is_offline(new) ||
   177				    blk_zone_is_readonly(new))
   178					old->cond = new->cond;
   179	
   180				if (blk_zone_in_update(old)) {
   181					old->cond = new->cond;
   182					old->wp = new->wp;
   183					blk_clear_zone_update(old);
   184				}
   185	
   186				blk_unlock_zone(old);
   187	
   188				kfree(new);
   189			}
   190	
   191			rec += 64;
   192	
   193		}
   194	
   195		return 0;
   196	}
   197	
   198	/**
   199	 * sd_zbc_report_zones - Issue a REPORT ZONES scsi command
   200	 * @sdkp: SCSI disk to which the command should be send
   201	 * @buffer: response buffer
   202	 * @bufflen: length of @buffer
   203	 * @start_sector: logical sector for the zone information should be reported
   204	 * @option: reporting option to be used
   205	 * @partial: flag to set the 'partial' bit for report zones command
   206	 */
   207	int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
   208				int bufflen, sector_t start_sector,
   209				enum zbc_zone_reporting_options option, bool partial)
   210	{
   211		struct scsi_device *sdp = sdkp->device;
   212		const int timeout = sdp->request_queue->rq_timeout;
   213		struct scsi_sense_hdr sshdr;
   214		sector_t start_lba = sectors_to_logical(sdkp->device, start_sector);
   215		unsigned char cmd[16];
   216		int result;
   217	
   218		if (!scsi_device_online(sdp))
   219			return -ENODEV;
   220	
 > 221		sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n",
   222			     start_lba, bufflen);
   223	
   224		memset(cmd, 0, 16);
   225		cmd[0] = ZBC_IN;
   226		cmd[1] = ZI_REPORT_ZONES;
   227		put_unaligned_be64(start_lba, &cmd[2]);
   228		put_unaligned_be32(bufflen, &cmd[10]);
   229		cmd[14] = (partial ? ZBC_REPORT_ZONE_PARTIAL : 0) | option;
   230		memset(buffer, 0, bufflen);
   231	
   232		result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
   233					buffer, bufflen, &sshdr,
   234					timeout, SD_MAX_RETRIES, NULL);
   235	
   236		if (result) {
 > 237			sd_zbc_err(sdkp,
   238				   "REPORT ZONES lba %zu failed with %d/%d\n",
   239				   start_lba, host_byte(result), driver_byte(result));
   240			return -EIO;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--ZPt4rx8FFjLCG7dd
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
U3FDhIGE0nJnmerRIA2jkuxI/x+vfHyD7G8DAA==

--ZPt4rx8FFjLCG7dd--

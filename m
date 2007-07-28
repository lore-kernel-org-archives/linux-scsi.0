From: Gabriel C <nix.or.die@googlemail.com>
Subject: BSG: BLK_DEV_BSG=y , BLOCK=n compile error
Date: Sat, 28 Jul 2007 14:54:02 +0200
Message-ID: <46AB3C6A.2070209@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:29545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbXG1M6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 08:58:06 -0400
Received: by ug-out-1314.google.com with SMTP id j3so828702ugf
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jul 2007 05:58:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

Hi,

BSG does not compile without BLOCK set :

...

block/bsg.c: In function 'blk_fill_sgv4_hdr_rq':
block/bsg.c:186: error: 'BLK_MAX_CDB' undeclared (first use in this function)
block/bsg.c:186: error: (Each undeclared identifier is reported only once
block/bsg.c:186: error: for each function it appears in.)
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:186: error: dereferencing pointer to incomplete type
block/bsg.c:188: error: dereferencing pointer to incomplete type
block/bsg.c:193: error: implicit declaration of function 'blk_verify_command'
block/bsg.c:193: error: dereferencing pointer to incomplete type
block/bsg.c:201: error: dereferencing pointer to incomplete type
block/bsg.c:202: error: dereferencing pointer to incomplete type
block/bsg.c:202: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
block/bsg.c:204: error: dereferencing pointer to incomplete type
block/bsg.c:205: error: dereferencing pointer to incomplete type
block/bsg.c:206: error: dereferencing pointer to incomplete type
block/bsg.c:206: error: dereferencing pointer to incomplete type
block/bsg.c:207: error: dereferencing pointer to incomplete type
block/bsg.c:208: error: dereferencing pointer to incomplete type
block/bsg.c:208: error: 'BLK_DEFAULT_SG_TIMEOUT' undeclared (first use in this function)
block/bsg.c: In function 'bsg_validate_sgv4_hdr':
block/bsg.c:223: error: 'BLK_MAX_CDB' undeclared (first use in this function)
block/bsg.c:225: error: dereferencing pointer to incomplete type
block/bsg.c:226: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_map_hdr':
block/bsg.c:270: error: implicit declaration of function 'blk_get_request'
block/bsg.c:270: warning: assignment makes pointer from integer without a cast
block/bsg.c:279: error: 'QUEUE_FLAG_BIDI' undeclared (first use in this function)
block/bsg.c:279: error: dereferencing pointer to incomplete type
block/bsg.c:279: error: dereferencing pointer to incomplete type
block/bsg.c:284: warning: assignment makes pointer from integer without a cast
block/bsg.c:289: error: dereferencing pointer to incomplete type
block/bsg.c:292: error: implicit declaration of function 'blk_rq_map_user'
block/bsg.c:313: error: implicit declaration of function 'blk_put_request'
block/bsg.c:315: error: implicit declaration of function 'blk_rq_unmap_user'
block/bsg.c:315: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_rq_end_io':
block/bsg.c:327: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_add_command':
block/bsg.c:351: error: dereferencing pointer to incomplete type
block/bsg.c:352: error: dereferencing pointer to incomplete type
block/bsg.c:358: error: dereferencing pointer to incomplete type
block/bsg.c:359: error: dereferencing pointer to incomplete type
block/bsg.c:360: error: dereferencing pointer to incomplete type
block/bsg.c:368: error: dereferencing pointer to incomplete type
block/bsg.c:369: error: implicit declaration of function 'blk_execute_rq_nowait'
block/bsg.c: In function 'blk_complete_sgv4_hdr_rq':
block/bsg.c:426: error: dereferencing pointer to incomplete type
block/bsg.c:427: error: dereferencing pointer to incomplete type
block/bsg.c:428: error: dereferencing pointer to incomplete type
block/bsg.c:432: error: dereferencing pointer to incomplete type
block/bsg.c:435: error: dereferencing pointer to incomplete type
block/bsg.c:436: error: dereferencing pointer to incomplete type
block/bsg.c:440: error: dereferencing pointer to incomplete type
block/bsg.c:447: error: dereferencing pointer to incomplete type
block/bsg.c:449: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_put_device':
block/bsg.c:723: error: implicit declaration of function 'blk_put_queue'
block/bsg.c: In function 'bsg_add_device':
block/bsg.c:745: error: dereferencing pointer to incomplete type
block/bsg.c:753: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_ioctl':
block/bsg.c:884: error: implicit declaration of function 'scsi_cmd_ioctl'
block/bsg.c:898: error: dereferencing pointer to incomplete type
block/bsg.c:899: error: dereferencing pointer to incomplete type
block/bsg.c:900: error: dereferencing pointer to incomplete type
block/bsg.c:901: error: implicit declaration of function 'blk_execute_rq'
block/bsg.c: In function 'bsg_unregister_queue':
block/bsg.c:933: error: dereferencing pointer to incomplete type
block/bsg.c:939: error: dereferencing pointer to incomplete type
block/bsg.c: In function 'bsg_register_queue':
block/bsg.c:967: error: dereferencing pointer to incomplete type
block/bsg.c:970: error: dereferencing pointer to incomplete type
block/bsg.c:1005: error: dereferencing pointer to incomplete type
block/bsg.c:1006: error: dereferencing pointer to incomplete type
make[1]: *** [block/bsg.o] Error 1
make: *** [block] Error 2
make: *** Waiting for unfinished jobs....

...

A solution would be to move 'endif # BLOCK' in block/Kconfig after config BLK_DEV_BSG and 
before source block/Kconfig.iosched but that would move BSG inside the BLOCK menu.

Regards,

Gabriel C

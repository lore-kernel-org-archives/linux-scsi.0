From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 12:56:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071489370.1385.2.camel@cala>
References: <1071483139.1433.3.camel@cala>  <3FDD9D52.2060405@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp12.tin.it ([212.216.176.206]:41871 "EHLO vsmtp12.tin.it")
	by vger.kernel.org with ESMTP id S263544AbTLOL4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 06:56:20 -0500
In-Reply-To: <3FDD9D52.2060405@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org

Il lun, 2003-12-15 alle 12:38, Fabien Salvi ha scritto:

> Hello, using qla2200 from qlogic is IMHO the good solution.
> I've already tested it a few months ago and it worked fine except very 
> poor performance (around 20MB/s with a Qlogic switch despite of no load 
> at all).
> 
Poor tcp/ip performance or scsi performance?

> You should send your compile errors...

Yeah!

Here is the complete log:

BTW: How can I compile drivers into kernel and not as modules?
Instructions in drivers are erroneuos (I like a .diff ...)

 make IP=1
cc -D__KERNEL__ -DMODULE -Wall -O -g -DUDEBUG -DLINUX -Dlinux -DINTAPI
-DEXPORT_SYMTAB -DMODVERSIONS -include
/usr/src/linux-2.4/include/linux/modversions.h
-I/usr/src/linux-2.4/include
-I/usr/src/linux-2.4/include/../drivers/scsi -falign-functions=2
-falign-jumps=2 -falign-loops=2 -Wall -Wstrict-prototypes
-fomit-frame-pointer -fno-strength-reduce -pipe -DCONFIG_X86_LOCAL_APIC
-fno-strict-aliasing -fno-common -mpreferred-stack-boundary=2
-march=i686 -DFC_IP_SUPPORT   -DSHT_HAS_HIGHMEM_IO     -c qla2200.c -o
qla2200.o
In file included from qla2200.c:43:
qla2x00.c: In function `qla2x00_process_response_queue':
qla2x00.c:11581: warning: passing arg 2 of `qla2x00_ip_receive' from
incompatible pointer type
In file included from qla2200.c:43:
qla2x00.c: In function `qla2x00_register_snn':
qla2x00.c:14640: error: incompatible types in assignment
qla2x00.c:14641: error: incompatible types in assignment
In file included from qla2200.c:43:
qla2x00.c: In function `qla2x00_configure_local_loop':
qla2x00.c:16664: error: `list_entry_loop_id' undeclared (first use in
this function)
qla2x00.c:16664: error: (Each undeclared identifier is reported only
once
qla2x00.c:16664: error: for each function it appears in.)
In file included from qla2x00.c:18823,
                 from qla2200.c:43:
qla_cfg.c: In function `qla2x00_add_portname_to_mp_dev':
qla_cfg.c:1045: warning: comparison is always true due to limited range
of data type
qla_cfg.c:1057: warning: comparison is always false due to limited range
of data type
In file included from qla2x00.c:18823,
                 from qla2200.c:43:
qla_cfg.c: In function `qla2x00_find_mp_dev_by_id':
qla_cfg.c:3575: warning: comparison is always true due to limited range
of data type
In file included from qla2x00.c:18824,
                 from qla2200.c:43:
qla_fo.c: In function `qla2x00_fo_set_lun_data':
qla_fo.c:759: warning: comparison is always false due to limited range
of data type
In file included from qla2x00.c:18824,
                 from qla2200.c:43:
qla_fo.c: In function `qla2x00_fo_get_tgt':
qla_fo.c:1135: warning: comparison is always true due to limited range
of data type
qla_fo.c:1225: warning: comparison is always true due to limited range
of data type
make: *** [qla2200.o] Error 1

-- 
Mario Giammarco



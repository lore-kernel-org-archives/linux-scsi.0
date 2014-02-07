From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug #3] arcmsr: Sparse finds has many warnings and errors
Date: Fri, 7 Feb 2014 16:02:04 +0300
Message-ID: <20140207130204.GD6971@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaBGNCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 08:02:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw, erich@areca.com.tw
Cc: linux-scsi@vger.kernel.org, support@areca.com.tw

This file has many many Sparse warnings.  Most of them are just a matter
of using correct __iomem tags but some are real bugs where we
dereference __iomem pointers.  Can you take a look?

regards,
dan carpenter

drivers/scsi/arcmsr/arcmsr_hba.c:81:19: warning: symbol 'wait_q' was not declared. Should it be static?
drivers/scsi/arcmsr/arcmsr_hba.c:2582:54: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:2586:83: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2586:83:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2586:83:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2587:72: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2587:72:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2587:72:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2588:66: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2588:66:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2588:66:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2589:72: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2589:72:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2589:72:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:840:46: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:842:36: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:842:36:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:842:36:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:843:67: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:843:67:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:843:67:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2655:48: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2655:48:    expected struct MessageUnit_B [noderef] <asn:2>*reg
drivers/scsi/arcmsr/arcmsr_hba.c:2655:48:    got struct MessageUnit_B *pmuB
drivers/scsi/arcmsr/arcmsr_hba.c:568:57: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:568:57:    expected struct MessageUnit_C *reg
drivers/scsi/arcmsr/arcmsr_hba.c:568:57:    got struct MessageUnit_C [noderef] <asn:2>*pmuC
drivers/scsi/arcmsr/arcmsr_hba.c:1575:41: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1575:41:    expected struct MessageUnit_C *reg
drivers/scsi/arcmsr/arcmsr_hba.c:1575:41:    got struct MessageUnit_C [noderef] <asn:2>*pmuC
drivers/scsi/arcmsr/arcmsr_hba.c:1577:71: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1577:71:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1577:71:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:352:41: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:356:28: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:356:28:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:356:28:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:359:34: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:359:34:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:359:34:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:402:38: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:404:51: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:404:51:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:404:51:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:405:56: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:405:56:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:405:56:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:741:38: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:742:49: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:742:49:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:742:49:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:743:56: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:743:56:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:743:56:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:964:65: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:964:65:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:964:65:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:965:61: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:965:61:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:965:61:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:978:48: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:978:48:    expected struct MessageUnit_C *reg
drivers/scsi/arcmsr/arcmsr_hba.c:978:48:    got struct MessageUnit_C [noderef] <asn:2>*pmuC
drivers/scsi/arcmsr/arcmsr_hba.c:983:32: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:983:32:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:983:32:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:985:43: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:985:43:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:985:43:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1094:48: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1094:48:    expected struct MessageUnit_C *reg
drivers/scsi/arcmsr/arcmsr_hba.c:1094:48:    got struct MessageUnit_C [noderef] <asn:2>*pmuC
drivers/scsi/arcmsr/arcmsr_hba.c:1096:45: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1096:45:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1096:45:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1181:45: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1181:45:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1181:45:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:1184:68: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1184:68:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1184:68:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:1186:71: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1186:71:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1186:71:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:1195:49: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1201:56: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1201:56:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1201:56:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1202:49: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1202:49:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1202:49:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1204:49: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1204:49:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1204:49:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1237:38: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1239:49: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1239:49:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1239:49:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1240:56: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1240:56:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1240:56:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1343:49: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1367:46: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1392:42: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1392:42:    expected void const *from
drivers/scsi/arcmsr/arcmsr_hba.c:1392:42:    got unsigned char [noderef] [usertype] <asn:2>*[assigned] iop_data
drivers/scsi/arcmsr/arcmsr_hba.c:1423:32: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1423:32:    expected void *to
drivers/scsi/arcmsr/arcmsr_hba.c:1423:32:    got unsigned char [noderef] [usertype] <asn:2>*[assigned] iop_data
drivers/scsi/arcmsr/arcmsr_hba.c:1456:38: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1464:36: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1464:36:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1464:36:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1465:36: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1465:36:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1465:36:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1500:52: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1500:52:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1500:52:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:1501:45: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1501:45:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1501:45:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:1520:19: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1524:23: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1524:23:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1524:23:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1527:27: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1527:27:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1527:27:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1535:68: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1535:68:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1535:68:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1551:41: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1551:41:    expected struct MessageUnit_A *reg
drivers/scsi/arcmsr/arcmsr_hba.c:1551:41:    got struct MessageUnit_A [noderef] <asn:2>*pmuA
drivers/scsi/arcmsr/arcmsr_hba.c:1553:50: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1553:50:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1553:50:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1637:41: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:1643:40: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1643:40:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:1643:40:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1713:32: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:1713:32:    expected void *to
drivers/scsi/arcmsr/arcmsr_hba.c:1713:32:    got unsigned char [noderef] [usertype] <asn:2>*[assigned] iop_data
drivers/scsi/arcmsr/arcmsr_hba.c:2002:24: warning: Using plain integer as NULL pointer
drivers/scsi/arcmsr/arcmsr_hba.c:2237:41: warning: incorrect type in initializer (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2237:41:    expected struct MessageUnit_C *reg
drivers/scsi/arcmsr/arcmsr_hba.c:2237:41:    got struct MessageUnit_C [noderef] <asn:2>*pmuC
drivers/scsi/arcmsr/arcmsr_hba.c:2244:30: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2244:30:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2244:30:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2245:61: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2245:61:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2245:61:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2248:41: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2248:41:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2248:41:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2251:50: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2251:50:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2251:50:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2252:56: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2252:56:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2252:56:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2255:28: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2255:28:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2255:28:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2256:87: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2256:87:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2256:87:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2268:41: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2268:41:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2268:41:    got char *iop_firm_model
drivers/scsi/arcmsr/arcmsr_hba.c:2275:43: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2275:43:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2275:43:    got char *iop_firm_version
drivers/scsi/arcmsr/arcmsr_hba.c:2284:62: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2284:62:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2284:62:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2285:64: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2285:64:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2285:64:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2286:61: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2286:61:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2286:61:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2287:62: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2287:62:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2287:62:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2288:62: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2288:62:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2288:62:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2374:57: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2374:57:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2374:57:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2387:45: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2387:45:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2387:45:    got unsigned int *
drivers/scsi/arcmsr/arcmsr_hba.c:2424:38: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:2434:29: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2434:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2434:29:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2447:35: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2447:35:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2447:35:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2623:46: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:2625:49: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2625:49:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2625:49:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2740:41: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:2742:50: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2742:50:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2742:50:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2743:56: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2743:56:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2743:56:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2787:46: warning: cast removes address space of expression
drivers/scsi/arcmsr/arcmsr_hba.c:2790:44: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2790:44:    expected void const volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2790:44:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2791:44: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2791:44:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2791:44:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:2792:60: warning: incorrect type in argument 2 (different address spaces)
drivers/scsi/arcmsr/arcmsr_hba.c:2792:60:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/arcmsr/arcmsr_hba.c:2792:60:    got unsigned int *<noident>
drivers/scsi/arcmsr/arcmsr_hba.c:1385:19: warning: dereference of noderef expression
drivers/scsi/arcmsr/arcmsr_hba.c:1429:17: warning: dereference of noderef expression
drivers/scsi/arcmsr/arcmsr_hba.c:1720:17: warning: dereference of noderef expression
drivers/scsi/arcmsr/arcmsr_hba.c:2669:51: warning: dereference of noderef expression

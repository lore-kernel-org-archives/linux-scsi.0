From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: Problems with updated firmware for qla2xxx driver.
Date: Tue, 23 Mar 2004 11:47:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE0351BCF5@orsmsx404.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr05.intel.com ([134.134.136.6]:26030 "EHLO
	hermes.jf.intel.com") by vger.kernel.org with ESMTP id S262784AbUCWTsV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 14:48:21 -0500
Received: from talaria.jf.intel.com (talaria.jf.intel.com [10.7.209.7])
	by hermes.jf.intel.com (8.12.9-20030918-01/8.12.9/d: major-outer.mc,v 1.15 2004/01/30 18:16:28 root Exp $) with ESMTP id i2NJqKkS024572
	for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2004 19:52:22 GMT
Received: from orsmsxvs040.jf.intel.com (orsmsxvs040.jf.intel.com [192.168.65.206])
	by talaria.jf.intel.com (8.12.9-20030918-01/8.12.9/d: major-inner.mc,v 1.10 2004/03/01 19:21:36 root Exp $) with SMTP id i2NJedgZ007698
	for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2004 19:41:16 GMT
Received: from orsmsx332.amr.corp.intel.com ([192.168.65.60])
 by orsmsxvs040.jf.intel.com (SAVSMTP 3.1.2.35) with SMTP id M2004032311475202682
 for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2004 11:47:52 -0800
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
	I am trying to run the latest qla2xxx driver with the patches from <ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/> on an Intel AdvancedTCA SBC  which has an onboard dual port QLogic ISP2312 controller. When I insmod the driver the adapter is found and the driver tries to "init" the firmware and fails. It looks like this is due to the  firmware in driver versions > 8.00.00b8. The same driver works fine if  I copy the qla2300_fw.c file from an earlier version (8.00.00b8) found in the stock 2.6.2 kernel. Has anybody else noticed this on other ISP2312 based adapters. Appreciate any help resolving this issue. 
Ramesh.    


"Views expressed are mine, and not those of Intel Corporation" 


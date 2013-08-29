From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID
 Adapter Driver
Date: Thu, 29 Aug 2013 11:45:33 +0300
Message-ID: <20130829084533.GC14334@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29575 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3H2Ipm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 04:45:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bgrove@attotech.com
Cc: linux-scsi@vger.kernel.org

Hello Bradley Grove,

This is a semi-automatic email about new static checker warnings.

The patch 17adeb6dabbe: "[SCSI] esas2r: ATTO Technology ExpressSAS 6G 
SAS/SATA RAID Adapter Driver" from Aug 23, 2013, leads to the 
following Smatch complaint:

drivers/scsi/esas2r/esas2r_init.c:671 esas2r_cleanup()
	 warn: variable dereferenced before check 'host' (see line 668)

drivers/scsi/esas2r/esas2r_init.c
   667	{
   668		struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
                                                                    ^^^^^^^^^^^^^^
Patch adds dereference.

   669		int index;
   670	
   671		if (host == NULL) {
                    ^^^^^^^^^^^^
Patch adds check.

   672			int i;
   673	

regards,
dan carpenter

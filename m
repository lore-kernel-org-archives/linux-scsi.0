From: =?utf-8?B?bmlja2NoZW5nKOmEreWuiOismSk=?= <nick.cheng@areca.com.tw>
Subject: RE: [PATCH] scsi: improve areca driver stability and compatibility
Date: Wed, 6 Jun 2007 08:57:05 +0800
Message-ID: <000001c7a7d5$9bcfd4b0$5e00a8c0@51091008491>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:63895 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754826AbXFFA5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2007 20:57:13 -0400
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw

Subject: [PATCH] scsi: improve areca driver stability and compatibility
    
From: Nick Cheng <nick.cheng@areca.com.tw>
    
Description:
    1. Implement PCI-Express error recovery function and AER capability
    2. Implement the selection of ARCMSR_MAX_XFER_SECTORS_B=4096 if firmware     version is latter than 1.42
    3. Add arcmsr_done4_abort_postqueue in arcmsr_iop_reset function to improve the stability as hot-unplug/plug
    4. Modify the ISR, arcmsr_interrupt routine, to prevent the inconsistency with sg_mod driver if application directly calls the arcmsr driver w/o passing through scsi mid layer specially thanks to Yanmin Zhang's openhanded help about AER
    
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>


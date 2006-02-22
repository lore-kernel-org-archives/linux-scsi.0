From: Stephan Rattai <srattai@zmnh.uni-hamburg.de>
Subject: aic79xx
Date: Wed, 22 Feb 2006 16:18:58 +0100
Message-ID: <200602221618.58553.srattai@zmnh.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rzaixsrv2.rrz.uni-hamburg.de ([134.100.32.71]:45255 "EHLO
	rzaixsrv2.rrz.uni-hamburg.de") by vger.kernel.org with ESMTP
	id S1751318AbWBVPTG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 10:19:06 -0500
Received: from mail.zmnh.uni-hamburg.de (mail.zmnh.uni-hamburg.de [134.100.101.11])
	by rzaixsrv2.rrz.uni-hamburg.de (8.12.10/8.12.9) with ESMTP id k1MFJ4h6108918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 16:19:04 +0100
Received: from snoopy.zmnh.uni-hamburg.de (snoopy.zmnh.uni-hamburg.de [192.168.100.1])
	by mail.zmnh.uni-hamburg.de (8.13.3/8.13.3) with ESMTP id k1MFIxNj006353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 16:18:59 +0100
Received: from konfuzius.zmnh.uni-hamburg.de (localhost [127.0.0.1])
	by snoopy.zmnh.uni-hamburg.de (8.13.4/8.13.4) with ESMTP id k1MFIxdj007192
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 16:18:59 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi list,

I would like to bother you with a problem that might be a little discrepancy 
in the aic79xx driver. I'm not quite sure if this is a aic79xx problem at 
all. I have an Adaptec 29320 controller with a LTO (U320) drive connected. I 
needed to turn down the speed to 160 which I did via the adapter bios. After 
having booted I found the following output in /proc/scsi/aic79xx/1:

Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, 16bit)
        Goal: 320.000MB/s transfers (160.000MHz DT|IU|RTI, 16bit)
        Curr: 320.000MB/s transfers (160.000MHz DT|IU|RTI, 16bit)
     
So the speed for the device is set to 320 despite my bios setting (at least 
that's what I'm being told through the proc interface). 

With kernel 2.6.13 I get:

Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz RDSTRM|DT, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT, 16bit)

Is this a bug or a feature ? 

Regards
Stephan

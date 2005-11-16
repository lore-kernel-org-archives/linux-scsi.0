From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Wed, 16 Nov 2005 16:09:26 -0500
Message-ID: <437BA006.8070307@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:27871 "EHLO
	ccerelbas02.cce.hp.com") by vger.kernel.org with ESMTP
	id S932601AbVKPVCc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 16:02:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mstone@mathom.us

This sounds very much like the issue I just posted (regarding an MPT 
adapter - U320 SCSI negotiation problem in Linux 2.6.13 and later 
implementations on LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT 
Dual Ultra320 SCSI (rev 08)) - perhaps the AIC79xx driver has a similar 
issue where it doesn't handle some new parallel capabilities being shown 
by 2.6.13 (and later) kernels?

Alan D. Brunelle

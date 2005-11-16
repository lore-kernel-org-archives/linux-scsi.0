From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: re: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Wed, 16 Nov 2005 16:23:59 -0500
Message-ID: <437BA36F.10600@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:1199 "EHLO
	ccerelbas03.cce.hp.com") by vger.kernel.org with ESMTP
	id S932605AbVKPVRI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 16:17:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michael.renner@geizhals.at

I'm seeing what looks to be the same problem (see: U320 SCSI negotiation 
problem in Linux 2.6.13 and later implementations on LSI Logic / Symbios 
Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)). [[I think I 
have a patch (perhaps suspect, but it works for me), if you're interested.]]

Alan D. Brunelle

From: mailinglist-linux-scsi@adazims.com
Subject: I2C/SGPIO on Marvell 88SE6440 (mvsas)
Date: Thu, 06 Mar 2014 17:01:15 +0100
Message-ID: <a7785ecf2bf2bcc750209dfd290812de@adazims.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.adazims.com ([185.35.78.64]:37528 "EHLO mail.adazims.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbaCFQK6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2014 11:10:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I have one Adaptec 1405 card with a Marvell 88SE6440 chip (mvsas). The 
card has one SFF-8087 connector with integrated I2C/SGPIO. On the other 
side my cable is SFF-8484 and connected to one simple 4x SAS/SATA 
backplane without RAID logic (sas/sata lines are directly routed to 
HDDs).

The problem with the backplane is that it controls SATA's pin 15 and the 
hard drives do not spin-up unless instructed to. This operation is 
handled by a PCA9556 chip located directly on the backplane.

My question is, how can I talk to this PCA9556 chip using mvsas driver? 
Or alternatively, where to get info, what needs to be written for 
"mvsas" to get this working?

Sincerely,
Dennis

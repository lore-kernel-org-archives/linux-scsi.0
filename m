From: Aldo Gavioli <aldo.gavioli@netstorage.it>
Subject: Sd driver on kernel 2.6
Date: Sun, 22 May 2005 22:04:07 +0200
Message-ID: <4290E5B7.2090300@netstorage.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout01.attiva.biz ([85.37.16.8]:63768 "EHLO
	smtpout01.attiva.biz") by vger.kernel.org with ESMTP
	id S261654AbVEVUEQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 16:04:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello All,
I'm trying to attach one proprietary SCSI driver for optical disk on 
kernel 2.6.
I noted that if sd attach the same device before my driver will never be 
called in the probe function.
How can I by-pass this situation ?
If anyone can help me I appreciate very much.
Thanks
Aldo

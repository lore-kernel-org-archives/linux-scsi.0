From: Gal Rosen <galr@storwize.com>
Subject: Qlogic virtual port creation issue
Date: Thu, 31 Dec 2009 09:49:10 +0200
Message-ID: <1262245750.26142.25.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.storwize.com ([212.179.166.116]:38066 "EHLO
	barracuda.storwize.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752069AbZLaIIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Dec 2009 03:08:24 -0500
Received: from swdc2.storwiz.com (localhost [127.0.0.1])
	by barracuda.storwize.com (Spam & Virus Firewall) with ESMTP id 2852A1D5FA
	for <linux-scsi@vger.kernel.org>; Thu, 31 Dec 2009 09:54:28 +0200 (IST)
Received: from swdc2.storwiz.com ([10.10.10.11]) by barracuda.storwize.com with ESMTP id wF3JR6R3vBmllB2e for <linux-scsi@vger.kernel.org>; Thu, 31 Dec 2009 09:54:28 +0200 (IST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Gal Rosen <galr@storwize.com>

Hi all.

Creation of several vport could take minutes.

The iocb called from qla24xx_modify_vp_config sometimes take 20 seconds
to returns.

So creation for let's say 60 vports sometimes can take really fast (25
seconds), and in other times 10 to 20 minutes.

It seems as a firmware issue, does anybody notice it ?
is there any solution for it ?

Thanks,
Gal.

 

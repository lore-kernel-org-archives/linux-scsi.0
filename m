From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: scsi_track_queue_full function - static values ?
Date: Tue, 07 Mar 2006 14:32:44 +0100
Message-ID: <440D8B7C.9020001@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32424 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1750828AbWCGNcs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 08:32:48 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B5EED19D906
	for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2006 14:32:49 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30018-03 for <linux-scsi@vger.kernel.org>;
 Tue,  7 Mar 2006 14:32:48 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 22A9719D912
	for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2006 14:32:48 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by openx3.frec.bull.fr (Postfix) with ESMTP id 0EF632B0EB
	for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2006 14:32:45 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,


I was looking at the scsi_track_queue_full (driver/scsi/scsi.c) function.

Can someone tell me how have been defined all the static values in this function ?

- we may have (max) 16 (>>4) jiffies between calls (else there's no need to call 
this function...),

- queue_full_depth_count should be > 10 (else queue depth still not changed),

- if lun queue depth < 8, lun queue depth is set with cmd_per_lun
(what's happen if cmd_per_lun > 8 ???)


May someone add some #define for these values ?
Is it a way to use 'auto-adapted' values ?

Best regards.

-- 
Frederic TEMPORELLI

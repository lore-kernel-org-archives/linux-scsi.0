From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Wed, 21 Mar 2012 17:16:45 -0600
Message-ID: <201203211716.45418.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:59806 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2CUXXh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2012 19:23:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

I recently got an IBM M1015 (MegaRaid 9240-8i) card, and after getting a new 
motherboard, the system now boots, but the megaraid_sas driver seems to be 
getting stuck when trying to initialize the card.

Looking through the source, it seems to be stuck in the megasas_adp_reset_gen2 
function, in the while loop at the end. Now, according to the code it can't 
actually get stuck there permanently, but it does take quite a while for the 
loop to finish, and the udev timeout messages to stop.

I've looked around quite a bit, but haven't found any solutions thus far. If 
anyone could point me in the right direction I'd appreciate it.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

From: "Stepan Novotill" <snovotill@hotmail.com>
Subject: urgent SCSI help please
Date: Tue, 30 Sep 2003 21:50:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BAY2-F170FSZDhd2stb00001311@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay2-f170.bay2.hotmail.com ([65.54.247.170]:4869 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S261899AbTJAEud
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2003 00:50:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

What does this mean in /var/log/messages when I read data from DTF2 tapes?

kernel: sym53c875-1-<5,*>: FAST-20 WIDE SCSI 40.0 MB/s (50.0 ns, offset 8)
last message repeated 11706 times
last message repeated 9539 times

Ive swapped out everything including all SCSI components, kernel versions, 
drivers, everything.

Funny the symbios driver (doesn't matter which flavor) won't load in 
/etc/modules.conf but will from rc.local on this PE2600 smp machine. There 
are two of these (HVD) Symbios-8751D cards installed.

Thanks from Stepan

_________________________________________________________________
MSN 8 with e-mail virus protection service: 2 months FREE*  
http://join.msn.com/?page=features/virus


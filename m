From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [Announce] sg3_utils-1.27 available
Date: Sat, 11 Apr 2009 19:24:07 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0904111917520.7984@filesrv1.baby-dragons.com>
References: <49E152F8.2020304@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.baby-dragons.com ([204.91.156.41]:59171 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZDLDdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2009 23:33:15 -0400
In-Reply-To: <49E152F8.2020304@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

 	Hello Doug ,  I thought sometime ago I'd mentioned the lack of support 
for device name(actuall filename) expansion in these tools .
 	I am aware that a simple 'for do' loop would acomplish the same thing 
but that requires writing a script/function in order to do something that 
bash/ksh/.../??? has had available for quite sometime now .
 	Would you please entertain the request to add the ability to use shell 
expansion of file expansion in the sg3 tools ?

 		Tia ,  JimL

$ sudo src/sginfo  /dev/sg[0-5]
INQUIRY response (cmd: 0x12)
----------------------------
Device Type                        0
Vendor:                    SEAGATE
Product:                   ST118273LW
Revision level:            6246

 	Only gives me device sg0 .

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+

From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: RE: MPT Fusion LSI22320 ,  Domain validation loops .
Date: Sun, 1 Apr 2007 17:55:00 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0704011743200.21023@filesrv1.baby-dragons.com>
References: <664A4EBB07F29743873A87CF62C26D70650FD9@NAMAIL4.ad.lsil.com>
 <Pine.LNX.4.64.0703202347010.27070@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0703232202020.21973@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0703311324090.3026@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.system-techniques.com ([204.91.156.41]:40648 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXDBAzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Apr 2007 20:55:04 -0400
In-Reply-To: <Pine.LNX.4.64.0703311324090.3026@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello Eric & All ,

On Sat, 31 Mar 2007, Mr. James W. Laferriere wrote:
> 	Hello Eric & All ,  As a further on the subject matter .  The very 
> same controllerworks flawlessly with the SuperMicro 4 bay U320 CSE-SCA-833S2 
> Backplane .
> 	So that (again) leaves the HP DS-SL13R-BA 4354R 14drive ultra3 
> racKmount cabinet w/ dualbus & dualps as the culprit .
>
> 	Does anyone have information on this disk chassis ?
> 	There is a rj45 connector on the opposite side from the vhdci 
> connectors .  Is that port usable for diagnostics ?  Maybe I can at least 
> determine what it is doing that fails so miserably .

 	Just tried attaching the same HP DS-SL13R-BA 4354R disk cabinet to the 
aic7902 embedded controller .  This produced essentially the same effects as 
when attached to the lsi22320 controller .

 	As a point to note ,  Not all of the 4352r's are capable of U320 ,  In 
point mine .
 	The u320controller -> u160 -> u320disks ,  seems to be causing these 
controllers to loose the ability to validate .  Or the drivers .

 	Output of the (attempt to) boot to linux 2.6.17.13 is here ...

http://www.baby-dragons.com/filesrv1b-aic79xx-problem.log

 	Hth ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+

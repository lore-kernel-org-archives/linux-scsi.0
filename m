From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: MPT Fusion LSI22320 ,  Hard lock during bonnie++ run .
Date: Wed, 18 Apr 2007 17:15:14 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0704181650310.3723@filesrv1.baby-dragons.com>
References: <664A4EBB07F29743873A87CF62C26D70650FD9@NAMAIL4.ad.lsil.com>
 <Pine.LNX.4.64.0703202347010.27070@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0703232202020.21973@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0703311324090.3026@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0704011743200.21023@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.baby-dragons.com ([204.91.156.41]:44117 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993021AbXDSAPP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 20:15:15 -0400
Received: from localhost (ns3.baby-dragons.com [204.91.156.41])
	by ns3.baby-dragons.com (8.13.8/8.13.8) with ESMTP id l3J0FEvl007410
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 00:15:14 GMT
In-Reply-To: <Pine.LNX.4.64.0704011743200.21023@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello All ,  Has anyone else had an occurance of hard lockup using a 
Fusion lsi22320 .  schema below  & partial log output .

      +-A-+[ sc933s2 jbod chassis ] With 7-FUJITSU-MAP3147NC
      |
      +-B-+[ sc933s2 jbod chassis ] With 7-FUJITSU-MAP3147NC
      |
      + lsi22320 in pci-64-133 slot
[ system ] a SuperServer 6035B-8R
      + aic7902 on board
      |
      +-A-+[ internally ] With 2-Compaq/Seagate-18GB-u320 & 2-FUJITSU-MAP3147NC
      |
      +-B-+[ internally ] With 4-FUJITSU-MAP3147NC

 	lsi22320 is attached to the sc933s2 on channels A & B ,
 	cable lengths are ~ 4 feet on both channels .

 	aic7902 is attached internally thru 'system' ,  a SuperServer 6035B-8R .

Kernel: Linux 2.6.21-rc4 ,  With the 'Domain validation loops' patch .

  root@(none):~ # ( time bonnie++-1.03a/bonnie++ -u0:0 -d /home -s 524288 ) 2>&1
  | tee 512GB-bonnie++-run-ext3-200704181557.log
Using uid:0, gid:0.
Writing with putc()...mptscsih: ioc0: attempting task abort! (sc=d0795800)
sd 4:0:3:0:
         command: <4>mptscsih: ioc1: attempting task abort! (sc=d8c28500)
sd 5:0:1:0:
         command: Read(10): 28 00 00 1d d1 b9 00 00 08 00
Read(10): 28 00 00 1e 12 b9 00 00 08 00
mptscsih: ioc1: WARNING - TM Handler for type=1: IOC Not operational (0xffffffff)!
sd 1:0:3:0: Attempting to queue an A
<System Hung hard>

You can get the whole log here .
http://www.baby-dragons.com/new-sc933s2-coming-online-to-linux-scsi.log

 	Any help is greatly appreciated .
 		JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+

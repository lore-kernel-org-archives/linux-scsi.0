From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.04 released
Date: Wed, 14 May 2003 21:47:28 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC22CD0.4050206@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:30218 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262032AbTENMlc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 08:41:32 -0400
Received: from torque.net (d-242-115.stlucia.uq.net.au [203.101.242.115])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4ECsHHO003034
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2003 22:54:17 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball and rpms can be found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement will be sent to freshmeat.net
shortly.

Changelog for sg3_utils-1.04 [20030513]
   - all remaining utilities in the main directory have man pages [thanks
     to Eric Schwartz <emschwar@debian.org> for 7 man pages]
   - add CREDITS file
   - sg_simple1, sg_simple2, sg_simple3, sg_simple4, sg_simple16 and
     scsi_inquiry: moved to the examples directory
   - sg_debug: moved to the archive directory
   - sg_modes: add '-subp=<n>' for sub page code, suggests 6/10 byte
     alternative if bad opcode sense received, flip -cpf flag to -pf,
     add page names for most peripheral types
   - sg_turs: default '-n=' argument to 1, only when '-n=1' print error
     message in full
   - sg_logs: print temperature "<not available>" for 255, '-t' switch
     for temperature (from either temperature or IE log page)
   - sg_dd: add '-odir=0|1' switch for O_DIRECT on block devices
   - sg_start: add '-imm', '-loej' and 'pc=<n>' switches plus man page
   - sg_readcap: add '-pmi' and 'lba=<n>' switches
   - open files O_NONBLOCK in sg_inq, sg_modes and sg_logs so they
     can be used on cd/dvd drivers when there is no disk present

Doug Gilbert



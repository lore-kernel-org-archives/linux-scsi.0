From: Harald Dunkel <harald.dunkel@aixigo.de>
Subject: iscsi (?): Unknown VPD Code: 0xc7
Date: Thu, 23 Mar 2017 20:27:03 +0100
Message-ID: <5cab3767-c2c8-7934-a3e8-c31d7abdf2ea@aixigo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.aixigo.de ([5.145.142.10]:16036 "EHLO mail.aixigo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751991AbdCWTdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Mar 2017 15:33:46 -0400
Received: from srvvm01.ac.aixigo.de (mail.ac.aixigo.de [172.19.96.11])
        by gate5a.ac.aixigo.de (OpenSMTPD) with ESMTPS id 8910d02b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-scsi@vger.kernel.org>;
        Thu, 23 Mar 2017 20:27:04 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi folks,

I am trying to use LIO on amd64 to provide block devices to some
AIX 6.1 and 7.1 hosts. It works pretty well, except that I cannot
create rootvg wpars on AIX 7.1. (rootvg wpars are containers
running on their own volume group.)

The error message on AIX is

bash-4.3# mkwpar -O -D rootvg=yes devname=hdisk3 -n sample
**********************************************************************
ERROR
mkwpar: 0960-587 hdisk3 has un-supported subclass type.

**********************************************************************


Kernel is 4.9.13 (Debian backports). It shows several (maybe unrelated)
lines in kernel.log

:
Mar 23 08:46:05 nasl003b kernel: [ 1172.226643] Unknown VPD Code: 0xc7
Mar 23 08:46:05 nasl003b kernel: [ 1172.279368] Unknown VPD Code: 0xc7
Mar 23 08:46:06 nasl003b kernel: [ 1172.331243] Unknown VPD Code: 0xc7
Mar 23 08:46:06 nasl003b kernel: [ 1172.380074] Unknown VPD Code: 0xc7
Mar 23 08:47:02 nasl003b kernel: [ 1229.106384] Unknown VPD Code: 0xc7
Mar 23 19:06:30 nasl003b kernel: [38396.514881] Unknown VPD Code: 0xc7
Mar 23 19:06:30 nasl003b kernel: [38396.576499] Unknown VPD Code: 0xc7
Mar 23 19:06:30 nasl003b kernel: [38396.624678] Unknown VPD Code: 0xc7
:

What is it trying to tell me?


Every helpful hint is highly appreciated
Harri

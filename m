From: Matthias Urlichs <matthias@urlichs.de>
Subject: Low-level reformat with different sector size: ?
Date: Fri, 29 Jun 2007 15:34:06 +0000 (UTC)
Message-ID: <f638pe$it6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:60801 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778AbXF2PeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jun 2007 11:34:18 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1I4IUB-0007EI-Mm
	for linux-scsi@vger.kernel.org; Fri, 29 Jun 2007 17:34:15 +0200
Received: from smurf.noris.de ([192.109.102.42])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jun 2007 17:34:15 +0200
Received: from matthias by smurf.noris.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jun 2007 17:34:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Yesterday I managed to buy a couple of SCA disks with a sector size of ...
*drumroll* ... 524.

What's the easiest way to re-format these to use 512 bytes?
Preferably without screwing up anything else on these things?

I tried sformat, which reported some rather broken
data:

# sformat
sformat SCSI format/analysis/repair utilities
Release 3.4, Copyright J. Schilling

scsibus0:
        0,0,0     0) *
        0,1,0     1) *
        0,2,0     2) 'S330L  !' 'C0
                                  P' '' Disk
        0,3,0     3) *
        0,4,0     4) 'S330L  !' 'C0' 'P?' Disk
        0,5,0     5) 'S330L  !' 'C0`P#  ' '?' Disk
        0,6,0     6) *
        0,7,0     7) *
Select target -1 (2 - 5)/<cr>:2
scsibus0 target 2:
        0,2,0     0) 'S330L  !' 'C0
                                  P' '' Disk
        0,2,1     1) *
        0,2,2     2) *
        0,2,3     3) *
        0,2,4     4) *
        0,2,5     5) *
        0,2,6     6) *
        0,2,7     7) *
Select lun -1 (0 - 0)/<cr>:0
scsibus0 target 2 lun 0
Device type    : Disk
Version        : 7
Response Format: 1
Vendor_info    : 'S330L  !'
Identifikation : 'C0
                   P'
Revision       : ''
Device seems to be: Generic CCS Disk.
sformat: PANIC Sectorsize.
#

... Oops?

Kernel: 2.6.22 (Ubuntu development)

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
I have seen the Great Pretender and he is not what he seems.


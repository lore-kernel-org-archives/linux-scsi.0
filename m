From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 0/9] pm8001 updates for scsi-misc.git (2.6.33)
Date: Mon, 7 Dec 2009 17:21:12 +0800
Message-ID: <B1DA6F706B1742F38A47B81FB81A3715@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53004 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275AbZLGJVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:21:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

Hi, James
I send 5 patches for pm8001 in 18th Nov, and It still out of misc tree. I
resend this patches by separate these patches to one fix in one patch and
along with other minor fix.

These patches are:
1/9 : Fix for sata io circular lock dependency.
2/9 : enhance error handle for io patch, when the port is down, fast return
phy down for it.
3/9 : fix endian issues 
4/9 : set SSC down-spreading only to get less error on some 6G device.
5/9 : fix potential NULL pointer dereference
6/9 : bit set pm8001_ha->flags
7/9 : do not reset local sata as it will not be found if reset.
8/9 : enable read HBA SAS address from VPD
9/9 : misc code cleanup
   
Because of mail client issues I will send the patch both in content for
reviewing and in attachment for applying.

Thanks
Jack Wang

Signed-off-by: Jack Wang <jack_wang@usish.com>


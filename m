From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 0/5] pm8001: 5 Patches for the driver
Date: Wed, 18 Nov 2009 17:16:45 +0800
Message-ID: <85E0D649126540A29CF7528716BB2CBE@usish.com.cn>
References: <20091118004049.GA10257@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45355 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZKRJQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 04:16:44 -0500
In-Reply-To: <20091118004049.GA10257@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

Hi James and all

 I am sending five patches. Some are inspired from mvsas patchset, thanks
for that.

1/5 : Fix for sata io circular lock dependency.

2/5 : enhance error handle for io patch, when the port is down ,fast return 
phy down for it.

3/5 :fix endian issues 

4/5 : This patch does a couple of very small, mostly
    single line changes which I feel will be an overkill to put in
    individual patches.

	1) delete unnecessary cast.
	2) fix potential NULL pointer dereference.
	3) bit set pm8001_ha->flags
	4) cleanup
	5) local sata do not reset as it will not be found if reset.
	
5/5 :set SSC down-spreading only to get less error on some 6G device.

The patch was built on the latest scsi-misc-2.6.git tree

I request that these patches  be applied to the next release

Thanks
Jack


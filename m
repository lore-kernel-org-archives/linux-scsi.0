From: "Jack Wang" <jack_wang@usish.com>
Subject: RE [PATCH] pm8001: support HDA (flashless) mode (take 2)
Date: Thu, 3 May 2012 08:35:13 +0800
Message-ID: <2275E35DFBB74B10B6049A728D6F46E3@usish.com.cn>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com> <C1F230B3-E151-495B-99A0-88739ACBBFCF@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:47621 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2ECAf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 20:35:59 -0400
In-Reply-To: <C1F230B3-E151-495B-99A0-88739ACBBFCF@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?gb2312?B?J9PasK67qic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

Hi Mark,

I found other issue in this patch need to be addressed. when HDA mode is
enable, we need also change the soft reset signature to HDA signature in
pci_remove/suspend/resume function.

and in pm8001_chip_init, check fw ready is not need for HDA mode.


Best regards

Jack



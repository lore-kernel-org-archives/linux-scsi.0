From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during
 I/O
Date: Tue, 7 Jun 2011 00:45:30 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FADEEF8A@SC-VEXCH4.marvell.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
 <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
 <4DE87A83.4090801@intel.com>
 <F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
 <BANLkTinv8Wb4S=46=gLF6FTz8Lphu3MmcA@mail.gmail.com>
 <32A6DF19414949D7ABD99B20EB14F34E@usish.com.cn>
 <3D59CDD5223B4C6AA9A4C9750EEECA12@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43555 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab1FGHpt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2011 03:45:49 -0400
In-Reply-To: <3D59CDD5223B4C6AA9A4C9750EEECA12@usish.com.cn>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, 'Bart Van Assche' <bvanassche@acm.org>
Cc: 'Dan Williams' <dan.j.williams@intel.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, 'Lindar Liu' <lindar_liu@usish.com>, 'Ankit Jain' <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>

>I update to 2.6.39.1, the panic seems disappear.
No, it still have.

To JBottomley@parallels.com:
Why did you remove MVSAS patches in version 2.6.39.1? 
(http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=0b15fb1fdfd403726542cb6111bc916b7a9f7fad)

Thanks!


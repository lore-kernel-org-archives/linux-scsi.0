From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
Date: Fri, 3 Jun 2011 09:13:28 +0200
Message-ID: <BANLkTinv8Wb4S=46=gLF6FTz8Lphu3MmcA@mail.gmail.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
 <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
 <4DE87A83.4090801@intel.com> <F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48306 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1FCHNt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 03:13:49 -0400
Received: by wya21 with SMTP id 21so1170414wya.19
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2011 00:13:48 -0700 (PDT)
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Lindar Liu <lindar_liu@usish.com>, Ankit Jain <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jun 3, 2011 at 8:45 AM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
> >On 6/2/2011 8:27 PM, Xiangliang Yu wrote:
> > > Hi, all
> > > I upgrade kernel version to 2.6.39 and find out a kernel panic when I test the MVSAS driver: kernel panic if hot-plug disk during I/O. But the driver is OK in version 2.6.37
>
> > If it is a stable reproduction can you bisect it?
> What I use is latest kernel version (2.6.39).

Although I'm not sure this will help, it might be worth trying
2.6.39.1. There are some block layer fixes in 2.6.39.1.

Bart.

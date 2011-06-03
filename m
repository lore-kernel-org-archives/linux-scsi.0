From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
Date: Fri, 3 Jun 2011 15:36:03 +0800
Message-ID: <32A6DF19414949D7ABD99B20EB14F34E@usish.com.cn>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6> <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com> <4DE87A83.4090801@intel.com> <F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com> <BANLkTinv8Wb4S=46=gLF6FTz8Lphu3MmcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:48180 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1FCHgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 03:36:08 -0400
In-Reply-To: <BANLkTinv8Wb4S=46=gLF6FTz8Lphu3MmcA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Bart Van Assche' <bvanassche@acm.org>, 'Xiangliang Yu' <yuxiangl@marvell.com>
Cc: 'Dan Williams' <dan.j.williams@intel.com>, JBottomley@parallels.com, 'Lindar Liu' <lindar_liu@usish.com>, 'Ankit Jain' <jankit@suse.de>, linux-scsi@vger.kernel.org

I can reproduce this panic in 2.6.39, and found 2.6.39rc1 works fine.

> 
> On Fri, Jun 3, 2011 at 8:45 AM, Xiangliang Yu <yuxiangl@marvell.com>
wrote:
> > >On 6/2/2011 8:27 PM, Xiangliang Yu wrote:
> > > > Hi, all
> > > > I upgrade kernel version to 2.6.39 and find out a kernel panic when
I
> test the MVSAS driver: kernel panic if hot-plug disk during I/O. But the
driver
> is OK in version 2.6.37
> >
> > > If it is a stable reproduction can you bisect it?
> > What I use is latest kernel version (2.6.39).
> 
> Although I'm not sure this will help, it might be worth trying
> 2.6.39.1. There are some block layer fixes in 2.6.39.1.
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during
 I/O
Date: Thu, 2 Jun 2011 23:45:39 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
 <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
  <F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
 <4DE87A83.4090801@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59057 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab1FCGte convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2011 02:49:34 -0400
In-Reply-To: <4DE87A83.4090801@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, 'Lindar Liu' <lindar_liu@usish.com>, 'Ankit Jain' <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O

>On 6/2/2011 8:27 PM, Xiangliang Yu wrote:
>> Hi, all
>> I upgrade kernel version to 2.6.39 and find out a kernel panic when I test the MVSAS driver: kernel panic if hot-plug disk during I/O. But the driver is OK in version 2.6.37

>If it is a stable reproduction can you bisect it?
What I use is latest kernel version (2.6.39).


From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
	2.6.14-rc1
Date: Mon, 19 Sep 2005 10:19:32 -0500
Message-ID: <1127143172.4869.1.camel@mulgrave>
References: <20050915190338.GA6807@kroah.com>
	 <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
	 <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave>
	 <1126818483.4821.60.camel@mulgrave> <20050915221946.GA28441@us.ibm.com>
	 <1126823917.4821.70.camel@mulgrave> <1127003717.4794.10.camel@mulgrave>
	 <1127073920.4847.34.camel@mulgrave>  <20050918220126.GA6317@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6060 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932462AbVISPVU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 11:21:20 -0400
In-Reply-To: <20050918220126.GA6317@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Sun, 2005-09-18 at 15:01 -0700, Greg KH wrote:
> Should I apply any additional patches too?  Or just this one will
> suffice?

Just to make assurances doubly sure, could you remove all the scsi
patches and just pull the scsi git tree at

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

into your build and verify that everything works (the module is
removable and the error thread stops).

Thanks,

James



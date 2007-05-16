From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Asynchronous scsi scanning
Date: Tue, 15 May 2007 19:59:39 -0700
Message-ID: <adabqglo4mc.fsf@cisco.com>
References: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
	<a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
	<a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
	<1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	<a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	<17841.simon.1179228389@5ec7c279.invalid>
	<20070515120228.GI10562@parisc-linux.org>
	<4649E03A.1090004@simon.arlott.org.uk>
	<20070515172905.GJ10562@parisc-linux.org>
	<a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	<20070516025121.GK10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:48045 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbXEPC7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 22:59:45 -0400
In-Reply-To: <20070516025121.GK10562@parisc-linux.org> (Matthew Wilcox's message of "Tue, 15 May 2007 20:51:21 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

 > No, it does matter.  Your suggestion doesn't work, because
 > /sys/module/scsi_mod/parameters/ belongs to the module code.  To create
 > a new attribute there, you use the module_param() code -- and there's
 > no way to have code called when your parameter is changed.

If I'm not misunderstanding what you're talking about, there is
actually a way to have code called when a module parameter is changed:
module_param_call().

 - R.

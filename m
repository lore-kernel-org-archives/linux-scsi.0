From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7x_x_x 6.2.36 && Aic79xx 1.3.10 Updates
Date: Thu, 13 Nov 2003 15:20:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <248620000.1068762043@aslan.btc.adaptec.com>
References: <3FB3DEBD.5050306@cs.uwaterloo.ca> <235850000.1068759765@aslan.btc.adaptec.com> <3FB401FF.7060208@cs.uwaterloo.ca>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12448 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264453AbTKMWQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 17:16:28 -0500
In-Reply-To: <3FB401FF.7060208@cs.uwaterloo.ca>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Louay Gammo <lgammo@cs.uwaterloo.ca>
Cc: linux-scsi@vger.kernel.org

> I got this tarball from your website: aic79xx-linux-2.4-20031106-tar.gz.
> I untarred on top on my private 2.4.20-8 kernel tree. Should I have deleted
> the aic7xxx directory before I did this?

It probably makes little difference so long as you get rid of all of the
.o and .???.flags files in that directory.

> I did use an older version of the binary driver RPM. I faced versioning
> problems at the RPM install script level 

Yes. Module versioning means that these binaries will not function on
anything but stock kernels.

Can you provide all of the messages that the driver outputs?  A dmesg
from a running system would be useful too.

--
Justin


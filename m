From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 16:18:22 -0500
Message-ID: <1152566303.4027.17.camel@mulgrave.il.steeleye.com>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
	 <44B27F74.9000806@torque.net>
	 <1152549628.7275.24.camel@mulgrave.il.steeleye.com>
	 <20060710170815.GD30179@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54957 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965308AbWGJWvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 18:51:17 -0400
In-Reply-To: <20060710170815.GD30179@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: dougg@torque.net, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-07-10 at 10:08 -0700, Mike Anderson wrote:
> Well as I mentioned before it would be good if the distro support was more
> widespread before we cutoff the old method. I received a lot of questions
> recently from qla2xxx users who where use to doing kernel testing with not
> the latest distro version. They ran into issues when trying
> linux-2.6.18-rc1 (or git tree versions) along with trying to get the
> firmware loading support to work on there distro. 

Well ... I'm not entirely sympathetic to this one ... if you install a
vanilla kernel on a distro, you get the headache of managing it.  Thus,
the only distros you should be testing the vanilla kernels on are the
bleeding edge ones, like rawhide or FC.

If you want to use the distro's deliberately stable release, like RHEL
or SLES, then you stick to the kernels that the vendor supplies or face
the consequences.

And the corollary is that if I never force a move to the firmware
loader, the bleeding edge distros will never pick it up, stablise it and
implant it into their stable releases ...

James



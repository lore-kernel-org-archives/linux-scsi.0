From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] printks in print_inquiry
Date: Sat, 20 May 2006 09:33:12 -0500
Message-ID: <1148135593.3529.9.camel@mulgrave.il.steeleye.com>
References: <20060511150015.GJ12272@parisc-linux.org>
	 <20060512170854.GA11215@us.ibm.com>
	 <20060513050059.GR12272@parisc-linux.org>
	 <20060518183652.GM1604@parisc-linux.org>
	 <20060518200957.GA29200@us.ibm.com>
	 <20060519190848.GA2826@parisc-linux.org> <446E1FDE.1080404@emulex.com>
	 <20060520141958.GE2826@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:65438 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964858AbWETOd3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 10:33:29 -0400
In-Reply-To: <20060520141958.GE2826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Sat, 2006-05-20 at 08:19 -0600, Matthew Wilcox wrote:
> Certainly -- but don't we get sysfs access to debug this kind of
> problem?
> Or do people sometimes have this problem and can't find their root
> device as a consequence?

send me you dmesg output is a far easier thing to ask non-linux experts
than send me the contents of the scsi_level sysfs parameter for the
relevant scsi_device (primarily because it's usually hard to work out
where in the tree this is).

So, until we have some kind of sysfs dump command that comes with every
distribution and we can tell someone to run and attach the output, I'd
really prefer to keep useful diagnostic information in dmesg.

James



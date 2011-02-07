From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Why using configfs as the only interface is wrong for a
	storage target
Date: Mon, 07 Feb 2011 12:01:29 -0800
Message-ID: <1297108889.13752.241.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36145 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1BGUBf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 15:01:35 -0500
In-Reply-To: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>

On Mon, 2011-02-07 at 12:41 +0100, Bart Van Assche wrote:
> On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Please consider the following patch series for mainline target code.
> > It consists of predominately configfs bugfixes uncovered with recent SLUB
> > poison testing, and proper removal of legacy procfs target_core_mib.c code.
> > Note that the complete set of fabric independent statistics (SCSI MIBs) and
> > fabric dependent statistics will be included as native configfs group context
> > 'per value' attribute series during the .39 time frame.
> 

<SNIP>

> As we all know, it is not possible for a
> storage target to make these directories appear / disappear
> automatically in configfs because of basic configfs design choices.
> 

Of course it's possible to drive configfs struct config_group creation
from kernel space.  That is a tool that was used during LIO v2.x -> v3.x
IOCTL -> CONFIGFS bringup and conversion, remember..?

However Joel as the configfs maintainer did not want this code in
mainline, and I dropped the patch from lio-core-2.6.git some time ago.
If you think this is a worth-while discussion to revist perhaps you
should re-create the logic, and address the issues that Joel had with
the original code.

--nab



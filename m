From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Mon, 11 Jul 2005 08:57:21 -0500
Message-ID: <1121090241.5045.3.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
	 <20050710033431.GB13883@havoc.gtf.org>
	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>
	 <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave>
	 <42D18171.8050207@s5r6.in-berlin.de>
	 <20050710202734.GI14956@phunnypharm.org>
	 <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>
	 <42D1A1EF.1060006@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49044 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261723AbVGKN52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2005 09:57:28 -0400
In-Reply-To: <42D1A1EF.1060006@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, Jeff Garzik <jgarzik@pobox.com>

On Mon, 2005-07-11 at 00:32 +0200, Stefan Richter wrote:
> I tested again with all conversions reactivated in sbp2 and with
> sdev->use_10_for_rw = 1, sdev->use_10_for_ms = 1 removed from
> sbp2scsi_slave_configure again --- i.e. the old pseudo TYPE_DISK
> mangling completely reinstated. This prevents the reboot and lets
> me access the disk again.
> 
> That is, scsi's mid or high level definitely needs protection from
> bogus TYPE_DISKs like this one --- in one way or another.

Could you get a trace of what's going on from the command response point
of view?  Doing a scsi_print_command() in the queuecommand() routine and
printing the return code and sense (with scsi_print_sense()) in the -
>done() should be sufficient.

Thanks,

James



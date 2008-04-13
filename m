From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 18:51:24 -0500
Message-ID: <1208130684.4707.70.camel@localhost.localdomain>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org>
	 <1208097071.4707.21.camel@localhost.localdomain>
	 <20080413164800.GA23094@animx.eu.org>
	 <1208105925.4707.27.camel@localhost.localdomain>
	 <20080413170644.GA1234@animx.eu.org>
	 <1208108263.4707.37.camel@localhost.localdomain>
	 <480287A2.7030308@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38072 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYDMXv2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 19:51:28 -0400
In-Reply-To: <480287A2.7030308@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Wakko Warner <wakko@animx.eu.org>, Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

On Mon, 2008-04-14 at 08:22 +1000, Douglas Gilbert wrote:
> > There is one final thought:  the reason the aic94xx has a queue depth of
> > 31 is because that's the maximum NCQ can support (well, it's 32 max, but
> > we need one command for error handling).  So, if the LSI shows a queue
> > depth of 64 it may be queueing internally as well.  You could try
> > lowering the lsi queue to 31 and seeing if it makes a difference.
> 
> If memory serves, I needed to upgrade the firmware on my
> MPT SAS fusion cards before the SCSI ATA PASS-THROUGH commands
> worked (properly). I'm a long way away from my hardware
> at the moment so I can't provide any further information
> (such as firmware version numbers).

OK, this prompted me to try mine, and it does work with my mptsas.  This
is all of my information from the sysfs files in the host directory:

active_mode:    Initiator
board_assembly: 03-01088-03B
board_name:     SAS3800X
board_tracer:   P185695005
can_queue:      127
cmd_per_lun:    7
debug_level:    00000000h
device_delay:   00
host_busy:      0
io_delay:       00
proc_name:      mptsas
sg_tablesize:   128
state:  running
supported_mode: Initiator
unchecked_isa_dma:      0
unique_id:      2
version_bios:   00.00.00.00
version_fw:     01.24.00.00
version_mpi:    105
version_nvdata_default: 2d02h
version_nvdata_persistent:      2d02h
version_product:        LSISAS1068 B0

James



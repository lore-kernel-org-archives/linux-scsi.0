From: David Zeuthen <david@fubar.dk>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 08 Jan 2008 15:25:19 -0500
Message-ID: <1199823919.25566.3.camel@oneill.fubar.dk>
References: <47837E06.5080406@novell.com>
	 <20080108140151.GD16309@parisc-linux.org>
	 <4783B93B.70307@s5r6.in-berlin.de>
	 <1199815847.3534.49.camel@localhost.localdomain>
	 <1199823031.3264.16.camel@oneill.fubar.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 128-177-28-166.ip.openhosting.com ([128.177.28.166]:47912 "EHLO
	zelenka.fubar.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYAHU1d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:27:33 -0500
In-Reply-To: <1199823031.3264.16.camel@oneill.fubar.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Tue, 2008-01-08 at 15:10 -0500, David Zeuthen wrote:
> Perhaps if you can point to what SCSI commands hald are sending it would
> be easier to debug. Any other ideas?

Also, if you can identify the name of the process image doing this it
would be helpful. I know both libipoddevice and libgpod both install
code that is executed by hald that sends SCSI commands to iPod's to get
the system info from recent iPod's (no longer available as a file).

FWIW, I've never seen any bugs like this on Fedora or maybe the Fedora
kernel maintainers never forwarded / reassigned them to me (and they
normally do this). If there's anything I can do to reproduce this or
otherwise help, please let me know.

      David



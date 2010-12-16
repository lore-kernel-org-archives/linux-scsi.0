From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [ANNOUNCE] UAS uasp.c driver available on github
Date: Thu, 16 Dec 2010 01:40:07 -0800 (PST)
Message-ID: <178171.36505.qm@web31804.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:30110 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752341Ab0LPJkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 04:40:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

--- On Mon, 12/13/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> The uasp.c driver is available on
> github at https://github.com/ltuikov/linux-2.6. The
> free-linux branch is a branch off of the master branch. The
> free-linux branch contains the following:
> 
>  * uasp.c driver which allows you to connect to USB
> Attached SCSI (UAS) devices and use them as SCSI devices.
> 
> The free-linux branch also includes the following patches:
> 
>  * 6e5eba [USB] Use normalized sense when emulating
> autosense,
>  * 245423 [SCSI] Retrieve the Caching mode page, and
>  * 67869f [BLOCK] Preliminary increasing tag sequence
> implementation.
> 
> The first two of those patches, 6e5eba and 245423, have
> been accepted into topic branches and should be merged in
> the next (or current) kernel release.
> 
> The 67869f patch is needed to eliminate TMF processing race
> conditions in case of multiple application clients issuing
> commands to the same I_T nexus as I described here: http://marc.info/?t=128902350400001&r=1&w=2.

A read-only git URL where you could pull from would be: git://github.com/ltuikov/linux-2.6.git

   Luben


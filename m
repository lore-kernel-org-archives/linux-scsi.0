From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: What is SCSI command 0xa0 ?
Date: Mon, 14 Feb 2005 13:53:30 -0800
Message-ID: <20050214215330.GA14426@us.ibm.com>
References: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org> <m3r7ji7rxp.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e34.co.us.ibm.com ([32.97.110.132]:30962 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261573AbVBNVxg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 16:53:36 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1ELrYMN459504
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2005 16:53:35 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1ELrYiW314256
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2005 14:53:34 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1ELrYTu021460
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2005 14:53:34 -0700
Content-Disposition: inline
In-Reply-To: <m3r7ji7rxp.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Samuel Colin <Samuel.Colin3@wanadoo.fr>

On Mon, Feb 14, 2005 at 10:27:46PM +0100, Matthias Andree wrote:

> "REPORT LUNS". This is probably only useful on media changers and
> perhaps disk arrays.

Yes. 

You can disable it completely or just for the broken device.

BLIST_NOREPORTLUN is 0x40000. On boot or scsi_mod loading, to disable for
all devices:

        [scsi_mod.]default_dev_flags=0x40000

Or for one device:

        [scsi_mod.]dev_flags="vendor:model:0x40000"

Or for one device via /proc after scsi_mod is running:

        echo "vendor:model:0x40000" > /proc/scsi/device_info

-- Patrick Mansfield

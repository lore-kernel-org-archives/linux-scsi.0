From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC & PATCH 2.6.9-rc1] Add Blacklist for RAID configuration luns
Date: Tue, 14 Sep 2004 07:40:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914144023.GA9524@beaverton.ibm.com>
References: <20040914063237.GA97486@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:28609 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269330AbUINOkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 10:40:35 -0400
Content-Disposition: inline
In-Reply-To: <20040914063237.GA97486@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

On Mon, Sep 13, 2004 at 11:32:37PM -0700, Jeremy Higdon wrote:
> Engenio RAIDs have special luns that are used for configuring the RAID.
> These luns have a device type of 0 (disk), but do not adhere to
> standard disk semantics.  To avoid having to parse potentially dozens
> of error messages during initialization, it's good to avoid attaching
> these devices to sd.  This can be done by changing the device type
> to RAID (0xC).

What error messages are output without your patch?

-- Patrick Mansfield

From: Andi Kleen <andi@firstfloor.org>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 17:45:14 +0100
Message-ID: <p738x2zosmd.fsf@bingen.suse.de>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:51181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYAIQpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jan 2008 11:45:15 -0500
In-Reply-To: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> (Jon Watte's message of "Tue\, 8 Jan 2008 23\:40\:12 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Watte <jwatte@gmail.com>
Cc: linux-scsi@vger.kernel.org

"Jon Watte" <jwatte@gmail.com> writes:
>
> Any help or pointers to self-help would be appreciated!

The usual mistake is to not enable CONFIG_BLK_DEV_SD

-Andi

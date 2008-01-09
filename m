From: "Jon Watte" <jwatte@gmail.com>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 9 Jan 2008 09:21:55 -0800
Message-ID: <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com>
	 <p738x2zosmd.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:16881 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYAIRV5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 12:21:57 -0500
Received: by wx-out-0506.google.com with SMTP id h31so162923wxd.4
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jan 2008 09:21:57 -0800 (PST)
In-Reply-To: <p738x2zosmd.fsf@bingen.suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org

Yes, that turns out to be the case. Thanks for the quick sanity check!
I wonder if it's possible to magically turn that on when selecting
AHCI support in menuconfig? That way, it'd be harder for someone else
to make the same mistake.

Cheers,

        / h+


On Jan 9, 2008 8:45 AM, Andi Kleen <andi@firstfloor.org> wrote:
> "Jon Watte" <jwatte@gmail.com> writes:
> >
> > Any help or pointers to self-help would be appreciated!
>
> The usual mistake is to not enable CONFIG_BLK_DEV_SD
>
> -Andi
>



-- 

--
Americans might object: there is no way we would sacrifice our living
standards for the benefit of people in the rest of the world.
Nevertheless, whether we get there willingly or not, we shall soon
have lower consumption rates, because our present rates are
unsustainable.

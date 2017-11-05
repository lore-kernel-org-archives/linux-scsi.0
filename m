From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3] scsi: require CAP_SYS_ADMIN to write to procfs
 interface
Date: Sun, 5 Nov 2017 11:29:42 +0100
Message-ID: <20171105102942.GA31503@kroah.com>
References: <20171105025635.10843-1-asarai@suse.de>
 <20171105073121.GB1431@kroah.com>
 <CAOviyagXOJE3JqYwd3hUNA+qL0cRVafDgma8FTvq9To9iBaYmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60545 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750933AbdKEK3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Nov 2017 05:29:30 -0500
Content-Disposition: inline
In-Reply-To: <CAOviyagXOJE3JqYwd3hUNA+qL0cRVafDgma8FTvq9To9iBaYmQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Aleksa Sarai <asarai@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, Valentin Rothberg <vrothberg@suse.com>, stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>


A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sun, Nov 05, 2017 at 08:11:20PM +1100, Aleksa Sarai wrote:
> I've booted it on a few of my laptops, and nothing seemed to break. Is
> there a particular test-suite you'd recommend that I run?

Workloads/tools that normally interact with this file would be the best
ones, right?  Odds are, your normal "laptop booting/running" mode does
not do anything with this file.

thanks,

greg k-h

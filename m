From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] isci, firmware: Remove isci fallback parameter blob and generator
Date: Tue, 3 Jan 2012 23:41:38 -0800
Message-ID: <CAA9_cmf1n82GSVOYebe6jmsFcoRR0yEK2iYfn4kgUaKw43mxrA@mail.gmail.com>
References: <1325179735.13595.46.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35572 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2ADHlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2012 02:41:39 -0500
Received: by vbbfc26 with SMTP id fc26so13136441vbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jan 2012 23:41:38 -0800 (PST)
In-Reply-To: <1325179735.13595.46.camel@deadeye>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Intel SCU Linux support <intel-linux-scu@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Dec 29, 2011 at 9:28 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> This parameter blob and generator program have been moved to the
> linux-firmware.git repository.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Applied.

I split out the updates for these files into a patch I'll submit to
linux-firmware.git, also rebased the pending series for the next merge
window (will resubmit shortly).

--
Dan

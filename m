From: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.9-rc3-mm3 fails to detect aic7xxx
Date: Thu, 07 Oct 2004 13:45:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097181937.25526.13.camel@localhost>
References: <1097178019.24355.39.camel@localhost>
	 <4165A369.60306@cybsft.com>  <4165A951.3060808@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:33444 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268213AbUJGUpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 16:45:53 -0400
In-Reply-To: <4165A951.3060808@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: "K.R. Foley" <kr@cybsft.com>, Andrew Morton <akpm@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 2004-10-07 at 13:38, Luben Tuikov wrote:
> It is most likely the PCI ID patch which went into those drivers.
> You can back out only that change (drivers/scsi/aic7xxx) and
> try it.  (assuming you haven't changed anything else)

There's a lot of other gunk around there.  Is there a patch just for
that changeset somewhere?

-- Dave


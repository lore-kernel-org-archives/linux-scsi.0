From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Mon, 3 Oct 2005 14:34:26 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0510031433030.6944@shark.he.net>
References: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
 <1128373305.5825.3.camel@mulgrave> <4341A325.5070406@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44748 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932690AbVJCVe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 17:34:28 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 14:34:26 -0700
In-Reply-To: <4341A325.5070406@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxppc64-dev@ozlabs.org

On Mon, 3 Oct 2005, Brian King wrote:

> James Bottomley wrote:
> > On Mon, 2005-10-03 at 15:26 -0500, brking@us.ibm.com wrote:
> >
> >>Add a .config option to default the scsi scan inquiry timeout.
> >>Due to a broken device (SCSI/ATA converter card) that is very
> >>common on IBM iSeries/pSeries machines, these architectures
> >>need a longer default inquiry timeout.
> >
> >
> > The inquiry timeout has already been changed a while ago to be a module
> > parameter (or kernel parameter) for this very case.  Why does it now
> > need to be a config option as well?
>
> So that when a distro goes off and builds a PPC64 install kernel,
> it can boot on one of these broken DVD-ROMs without requiring each
> distro to add special module options inside their initrd.

My reading on mailing lists is that distros prefer
module or kernel parameters more than they do kernel config
options (in general) because they are more dynamic -- it
allows them to build one kernel instead of many kernels
with various config options.

-- 
~Randy

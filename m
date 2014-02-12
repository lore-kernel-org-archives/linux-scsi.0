From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Wed, 12 Feb 2014 11:25:17 -0800
Message-ID: <CAA9_cmfVuCsRnDvjs5YWWn7-WbDVvyu=M2DNCaE8jsPH51906w@mail.gmail.com>
References: <52EC60C3.1080103@gentoo.org>
	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>
	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>
	<20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>
	<52FBB257.10304@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:63664 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaBLTZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 14:25:18 -0500
Received: by mail-qc0-f181.google.com with SMTP id e9so15988231qcy.40
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2014 11:25:17 -0800 (PST)
In-Reply-To: <52FBB257.10304@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Yao <ryao@gentoo.org>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "prometheanfire@gentoo.org" <prometheanfire@gentoo.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "kernel@gentoo.org" <kernel@gentoo.org>

On Wed, Feb 12, 2014 at 9:41 AM, Richard Yao <ryao@gentoo.org> wrote:
> You should use `git send-email` to send the patch to all of the people
> listed by get_maintainer.pl:

I see nothing wrong with the patch Joe originally submitted:
http://marc.info/?l=linux-scsi&m=138609455422179&w=2

>
> richard@desktop ~/devel/linux $ scripts/get_maintainer.pl --file
> drivers/scsi/scsi_transport_sas.c
> "James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
> SUBSYSTEM)
> linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
> linux-kernel@vger.kernel.org (open list)
>
> If I see that James E.J. Bottomley is already on CC for this discussion,
> but my recent (and first) experience submitting a patch for another
> subsystem was that they are ignored unless this strict procedure is
> followed.
>
> If the maintainer does not respond within a month after doing this, I
> suggest informing Linus Torvalds via email that the subsystem maintainer
> is non-responsive.
>

Just re-ping James, he'll get to it...

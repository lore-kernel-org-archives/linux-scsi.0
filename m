From: Lee Revell <rlrevell@joe-job.com>
Subject: Re: [patch] 2.6.9-rc1-mm1: megaraid_mbox.c compile error with gcc
	3.4
Date: Sat, 28 Aug 2004 16:17:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093724235.8611.67.camel@krustophenia.net>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC9BB@exa-atlanta>
	 <20040828130419.57a56cdd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viper.oldcity.dca.net ([216.158.38.4]:4017 "HELO
	viper.oldcity.dca.net") by vger.kernel.org with SMTP
	id S267976AbUH1URN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 16:17:13 -0400
In-Reply-To: <20040828130419.57a56cdd.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Mukker, Atul" <Atulm@lsil.com>, bunk@fs.tum.de, sreenib@lsil.com, Manojj@lsil.com, linux-kernel <linux-kernel@vger.kernel.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sat, 2004-08-28 at 16:04, Andrew Morton wrote:
> "Mukker, Atul" <Atulm@lsil.com> wrote:
> >
> > The driver and the patches with the re-ordered functions is available at
> >  ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.3.1/
> 
> I dunno about James, but I *really* dislike receiving patches by going and
> getting them from internet servers.  It breaks our commonly-used tools.  It
> loses authorship info.  It loses Signed-off-by: info.  There is no
> changelog.  All this means that your patch is more likely to be ignored by
> busy people.  Please, just email the diffs.
> 

The FAQ should be updated, as it recommends posting a link to large
patches, rather than splitting them up and posting that way.

Of course, there is a lot in the FAQ that needs updating...

Lee


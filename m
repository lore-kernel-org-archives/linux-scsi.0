From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/7] scsi/megaraid: fix sparse warnings
Date: Sat, 12 May 2012 13:02:21 +0000
Message-ID: <201205121302.21623.arnd@arndb.de>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org> <1336774168-26577-7-git-send-email-mathieu.poirier@linaro.org> <CAHtARFFnLrk0zQ7GeoiPX3Cyso9zq-05q+RyyeGN0v7q=Dm1gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab2ELNCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2012 09:02:25 -0400
In-Reply-To: <CAHtARFFnLrk0zQ7GeoiPX3Cyso9zq-05q+RyyeGN0v7q=Dm1gQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: mathieu.poirier@linaro.org, JBottomley@parallels.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday 11 May 2012, adam radford wrote:
> 
> On Fri, May 11, 2012 at 3:09 PM,  <mathieu.poirier@linaro.org> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> ...
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index bfd87fa..234ad74 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -51,55 +51,16 @@
> >  #include <scsi/scsi_device.h>
> >  #include <scsi/scsi_host.h>
> >
> > +#include "mega_common.h"
> 
> Do not include mega_common.h in the megaraid_sas driver.  It has
> nothing to do with this driver.  It is for the older Parallel SCSI
> megaraid drivers.

Ok. I think I first tried moving all declarations into mega_common.h
and then decided otherwise but forgot to remove that #include statement
again. Thanks for taking a look!

	Arnd

From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Wed, 6 Jan 2016 11:33:39 +0800
Message-ID: <20160106033339.GB21068@eguan.usersys.redhat.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
 <20160105115735.GA21068@eguan.usersys.redhat.com>
 <yq17fjnk28u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34577 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbcAFDeo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2016 22:34:44 -0500
Received: by mail-pf0-f182.google.com with SMTP id e65so178060766pfe.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2016 19:34:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <yq17fjnk28u.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 05, 2016 at 06:58:25PM -0500, Martin K. Petersen wrote:
> >>>>> "Eryu" == Eryu Guan <guaneryu@gmail.com> writes:
> 
> Eryu> Any updates on this? It's still reproducible with 4.4-rc8 kernel,
> Eryu> and still blocks some of my tests :)
> 
> http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/log/?h=4.4/scsi-fixes
> 
> It just hasn't made it to Linus yet...

Great to hear that, thanks! (I don't subscribe linux-scsi@ so didn't see
the patch sent out)

Eryu
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

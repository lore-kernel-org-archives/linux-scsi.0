From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
Date: Wed, 3 Oct 2012 15:46:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210031544080.20211@dhcp-1-104.brq.redhat.com>
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com> <yq1d32ph515.fsf@sermon.lab.mkp.net> <5047AAD9.90106@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab2JCNrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 09:47:09 -0400
In-Reply-To: <5047AAD9.90106@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Lukas Czerner <lczerner@redhat.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012, Douglas Gilbert wrote:

> Date: Wed, 05 Sep 2012 15:41:13 -0400
> From: Douglas Gilbert <dgilbert@interlog.com>
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Lukas Czerner <lczerner@redhat.com>, linux-scsi@vger.kernel.org,
>     JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com,
>     linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
> 
> On 12-08-17 12:11 PM, Martin K. Petersen wrote:
> > > > > > > "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> > 
> > Lukas> Currently it is possible to unmap one more block than user
> > Lukas> requested to due to the off-by-one error in unmap_region(). This
> > Lukas> is probably due to the fact that the end variable despite its
> > Lukas> name actually points to the last block to unmap + 1. However in
> > Lukas> the condition it is handled as the last block of the region to
> > Lukas> unmap.
> > 
> > Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>

James, could you please pick this one ?

Thanks!
-Lukas

From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
Date: Wed, 5 Sep 2012 15:35:39 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209051534110.509@new-host-2>
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com> <yq1d32ph515.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d32ph515.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 17 Aug 2012, Martin K. Petersen wrote:

> Date: Fri, 17 Aug 2012 12:11:50 -0400
> From: Martin K. Petersen <martin.petersen@oracle.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, tytso@mit.edu,
>     pbonzini@redhat.com, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
> 
> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> Lukas> Currently it is possible to unmap one more block than user
> Lukas> requested to due to the off-by-one error in unmap_region(). This
> Lukas> is probably due to the fact that the end variable despite its
> Lukas> name actually points to the last block to unmap + 1. However in
> Lukas> the condition it is handled as the last block of the region to
> Lukas> unmap.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

I am still not seeing it in anywhere, is this going in any time soon
?

Thanks!
-Lukas

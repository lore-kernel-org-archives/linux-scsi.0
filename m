From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
Date: Wed, 05 Sep 2012 15:41:13 -0400
Message-ID: <5047AAD9.90106@interlog.com>
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com> <yq1d32ph515.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d32ph515.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12-08-17 12:11 PM, Martin K. Petersen wrote:
>>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
>
> Lukas> Currently it is possible to unmap one more block than user
> Lukas> requested to due to the off-by-one error in unmap_region(). This
> Lukas> is probably due to the fact that the end variable despite its
> Lukas> name actually points to the last block to unmap + 1. However in
> Lukas> the condition it is handled as the last block of the region to
> Lukas> unmap.
>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

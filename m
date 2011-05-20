From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
Date: Fri, 20 May 2011 18:42:24 +0300
Message-ID: <4DD68BE0.6030003@panasas.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com> <1305840792-25877-9-git-send-email-jim.cromie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305840792-25877-9-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

On 05/20/2011 12:33 AM, Jim Cromie wrote:
> cc: Doug Gilbert <dgilbert@interlog.com>
> cc: linux-scsi@vger.kernel.org
> cc: Benny Halevy <bhalevy@panasas.com>
> cc: Boaz Harrosh <bharrosh@panasas.com>
> cc: osd-dev@open-osd.org
> cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> cc: linux-scsi@vger.kernel.org
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  drivers/scsi/osd/osd_uld.c |    6 +++---
>  drivers/scsi/pmcraid.c     |    3 +--
>  drivers/scsi/sg.c          |    6 +++---
>  drivers/scsi/st.c          |    7 +++----
>  4 files changed, 10 insertions(+), 12 deletions(-)

Do you have a git tree with all these that I can pull
and test?

Thanks
Boaz

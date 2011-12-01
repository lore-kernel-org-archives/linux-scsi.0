From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 0/6] ata port runtime power management support
Date: Thu, 01 Dec 2011 09:30:39 -0600
Message-ID: <1322753439.6920.21.camel@dabdike>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
	 <CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-01 at 22:09 +0800, Lin Ming wrote:
> On Mon, Nov 28, 2011 at 9:15 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > Hi all,
> >
> > This is the v4 patches to add ata port runtime pm support.
> > Applied on top of v3.2-rc2.
> >
> > Jeff, any comment on the ata patches?
> > James, any comment on the scsi patches?
> 
> Ping ...
> 
> Which git tree should these patches go into? ATA or SCSI?

>  drivers/ata/libata-core.c      |  154 ++++++++++++++++++++++------------------
>  drivers/ata/libata-scsi.c      |    3 +-
>  drivers/ata/libata-transport.c |    5 ++
>  drivers/ata/libata.h           |    1 +
>  drivers/scsi/scsi_error.c      |    5 +-
>  drivers/scsi/scsi_pm.c         |   16 ++++-
>  drivers/scsi/sd.c              |    5 ++
>  include/scsi/scsi_host.h       |    3 +
>  8 files changed, 118 insertions(+), 74 deletions(-)

I think the line count implies ATA since it's the most changed.

For the SCSI piece, the acks should come from Alan Stern, since real
SCSI doesn't use suspend/resume and the hooks were put in for the
benefit of USB storage.

James



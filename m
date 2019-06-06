From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: libsas, lldds: Use dev_is_expander()
Date: Thu, 6 Jun 2019 13:57:18 +0200
Message-ID: <CAMGffEnFWGdAYEr4mvTKfeDR4xRQwQneeDjaDSaj3gmGHY=i3Q@mail.gmail.com>
References: <1559751143-168560-1-git-send-email-john.garry@huawei.com> <e8ad370e-6528-2ab1-5001-ab3fa4dc5ae8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e8ad370e-6528-2ab1-5001-ab3fa4dc5ae8@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu <lindar_liu@usish.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 6, 2019 at 3:35 AM Jason Yan <yanaijie@huawei.com> wrote:
>
>
>
> On 2019/6/6 0:12, John Garry wrote:
> > Many times in libsas, and in LLDDs which use libsas, the check for an
> > expander device is re-implemented or open coded.
> >
> > Use dev_is_expander() instead. We rename this from
> > sas_dev_type_is_expander() to not spill so many lines in referencing.
> >
> > Signed-off-by: John Garry<john.garry@huawei.com>
>
> Cannot agree more=EF=BC=8C
>
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
>
Looks good, thanks Jason!

Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>

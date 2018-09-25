From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v4] scsi: ufs: Make sysfs attributes writable
Date: Tue, 25 Sep 2018 11:40:54 -0700
Message-ID: <CAD=FV=W7h_3LwV-P5_E58-3qOo7Y-yQDTDfSLoU1+3c_6ZF0cg@mail.gmail.com>
References: <20180808224454.243790-1-evgreen@chromium.org> <6dd8a547-7260-09b8-9096-8a1564b08e70@intel.com>
 <8fd05b2d-fa48-78af-6f1c-7e485c1008f6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8fd05b2d-fa48-78af-6f1c-7e485c1008f6@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Evan Green <evgreen@chromium.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, stanislav.nijnikov@wdc.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Bart.VanAssche@wdc.com, Adrian Hunter <adrian.hunter@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, Sep 4, 2018 at 3:29 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 22/08/18 14:00, Adrian Hunter wrote:
> > On 09/08/18 01:44, Evan Green wrote:
> >> This change makes the UFS controller's sysfs attributes writable, which
> >> will enable users to provision unprovisioned UFS devices, or
> >> re-provision unlocked UFS devices.
> >>
> >> Signed-off-by: Evan Green <evgreen@chromium.org>
> >
> > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> >
>
> This patch has my Ack and Reviewed-by: Stanislav Nijnikov, so can it be
> queued for v4.20?  There is also Evan's "[PATCH] scsi: ufs: Make sysfs flags
> writable"

Ping?

I came across this patch and Evan's other one and noticed that they
haven't been applied though a batch of other SCSI patches for 4.20
were applied about a week ago.  Martin: is there something about these
patches that needs to change before they can land?

We're about to land the two patches into the Chrome OS kernel tree
which will remove any built-in reminders we'll have to keep track of
upstream progress, so this is probably the final ping from this end
until the next major Chrome OS kernel rebase.  ;-)

-Doug

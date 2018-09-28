From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Execute START_STOP_UNIT during init
Date: Fri, 28 Sep 2018 16:09:28 -0700
Message-ID: <CAE=gft4iB_iHfZ10vtty1aC6BAevT_zGLd0Yh3P8=Cpg4pymew@mail.gmail.com>
References: <20180928230203.905-1-evgreen@chromium.org> <20180928230203.905-3-evgreen@chromium.org>
 <20180928230416.GA30772@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928230416.GA30772@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, adrian.hunter@intel.com, stanislav.nijnikov@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 28, 2018 at 4:04 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Sep 28, 2018 at 04:02:03PM -0700, Evan Green wrote:
> > For UFS devices that are provisioned to have an initial power mode
> > (bInitPowerMode) of "sleep", Linux will currently fail to enumerate
> > the device. This is because the UFS specification says that the
> > device must get a START_STOP_UNIT SCSI command to wake the unit
> > up before other common initialization features like the device
> > descriptor will be available to be read.
>
> Yikes, this is just completely broken in terms of scsi compliance.
>
> I think we should simply not support such devices.

Really? It's part of the UFS spec. The document I have specifies that
I shouldn't reproduce without permission, but it's in JESD220A section
7.2.4 UFS-Sleep Power Mode.
-Evan

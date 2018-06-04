From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH 4/7] scsi: ufs: sysfs: Document attribute writability
Date: Mon, 4 Jun 2018 08:39:48 -0700
Message-ID: <CAE=gft78ikHjaZXELHS=HiLdzoCcQx=oNs_P=7=HsY1j+o8UjQ@mail.gmail.com>
References: <20180529181740.195362-1-evgreen@chromium.org> <20180529181740.195362-5-evgreen@chromium.org>
 <c16dbf5a23c32a090cc84544f7a83f7dd0283d73.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c16dbf5a23c32a090cc84544f7a83f7dd0283d73.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart.VanAssche@wdc.com
Cc: jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>, Stanislav.Nijnikov@wdc.com, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 4, 2018 at 1:35 AM Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> On Tue, 2018-05-29 at 11:17 -0700, Evan Green wrote:
> > This change removes the read-only clauses from the documentation
> > for UFS attributes, which are now writable.
>
> Also for this patch, why is this a separate patch instead of having merged
> these changes into the patch that makes the attributes writable?
>
> Bart.

I'll squash it in.

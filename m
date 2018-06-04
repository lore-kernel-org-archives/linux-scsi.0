From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH 0/7] Enable UFS provisioning via Linux
Date: Mon, 4 Jun 2018 08:03:07 -0700
Message-ID: <CAE=gft65BVSFUm-tPEw+pGKS2Y_jbLMwUX=f8PR4aw=QF_sOMg@mail.gmail.com>
References: <20180529181740.195362-1-evgreen@chromium.org> <CAP2JTQJaYKoYANe6C68HnkVzT6eYUq9wJQxuy71LqQ72dacv_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAP2JTQJaYKoYANe6C68HnkVzT6eYUq9wJQxuy71LqQ72dacv_w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: chlrbgh0@gmail.com
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, stanislav.nijnikov@wdc.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Hi Kyuho,

On Mon, Jun 4, 2018 at 4:11 AM Kyuho Choi <chlrbgh0@gmail.com> wrote:
>
> Hi Evan,
>
> I've some question about end user's provisioning.
>
> On 5/30/18, Evan Green <evgreen@chromium.org> wrote:
> > This series enables provisioning UFS devices using the existing sysfs
> > interface. This functionality is primarily useful along the assembly
> > line, but might also be useful for end users that receive devices that
> > aren't locked down.
>
> As we knew, ufs are mainly adopted to boot device like mobile phone.
> Usally after  provisioning operation, every data in ufs (eg. Android :
> system, userdata, boot info and etc) would be removed. How end user
> download and flash all data to ufs?. dd or another download tools?.
>

You're right, the user would need to be booted into a RAM disk, or off
of removable media like micro SD, and use dd or custom tools to set up
data inside the new provisioning scheme. So yes, on a mobile phone, it
would be a fairly advanced end user.
-Evan

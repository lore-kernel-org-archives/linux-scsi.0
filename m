From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/2] Include protection information in iscsi header
Date: Thu, 05 Jun 2014 20:25:35 +0300
Message-ID: <5390A80F.5050305@dev.mellanox.co.il>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com> <CAL1RGDVpPstaXELznXNyUnr_yU95T2ctm63j_Lg0z1P=PY1dYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDVpPstaXELznXNyUnr_yU95T2ctm63j_Lg0z1P=PY1dYQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 6/3/2014 9:16 AM, Roland Dreier wrote:
> On Sun, Jun 1, 2014 at 9:19 AM, Sagi Grimberg <sagig@mellanox.com> wrote:
>> Although these patches involve 3 subsystems with different
>> maintainers (scsi, iser, target) I would prefer seeing these
>> patches included together.
> Why?  Because they break wire compatibility?
>
> I hate to say it but even if they're merged at the same time, you
> can't guarantee that targets and initiators will be updated together.


Yes that's true, but still I would like to avoid a kernel release that 
the target and initiator
can't talk to one another...

Sagi.

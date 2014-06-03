From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 0/2] Include protection information in iscsi header
Date: Mon, 2 Jun 2014 23:16:22 -0700
Message-ID: <CAL1RGDVpPstaXELznXNyUnr_yU95T2ctm63j_Lg0z1P=PY1dYQ@mail.gmail.com>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 1, 2014 at 9:19 AM, Sagi Grimberg <sagig@mellanox.com> wrote:
> Although these patches involve 3 subsystems with different
> maintainers (scsi, iser, target) I would prefer seeing these
> patches included together.

Why?  Because they break wire compatibility?

I hate to say it but even if they're merged at the same time, you
can't guarantee that targets and initiators will be updated together.

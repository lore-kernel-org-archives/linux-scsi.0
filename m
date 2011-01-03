From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd workqueue
Date: Mon, 3 Jan 2011 18:45:33 +0100
Message-ID: <AANLkTimSmStMdz8KTQB2k+p2kcVpm9KghZV1xDfuTOS4@mail.gmail.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-18-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294062595-30097-18-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 3, 2011 at 2:49 PM, Tejun Heo <tj@kernel.org> wrote:
> The target driver is not in the memory reclaim path and doesn't need =
a
> dedicated workqueue. =A0Drop vtgtd and use system_wq instead. =A0The =
used
> work item is sync flushed on removal.

[ ... ]

Hi Tejun,

No matter which storage target will go upstream, I'm afraid that this
patch will conflict with it. See e.g.
http://dchs.spinics.net/lists/linux-scsi/msg49105.html.

Bart.

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd
 workqueue
Date: Tue, 4 Jan 2011 06:20:27 +0100
Message-ID: <20110104052027.GC6748@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-18-git-send-email-tj@kernel.org>
 <AANLkTimSmStMdz8KTQB2k+p2kcVpm9KghZV1xDfuTOS4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimSmStMdz8KTQB2k+p2kcVpm9KghZV1xDfuTOS4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 06:45:33PM +0100, Bart Van Assche wrote:
> No matter which storage target will go upstream, I'm afraid that this
> patch will conflict with it. See e.g.
> http://dchs.spinics.net/lists/linux-scsi/msg49105.html.

Ah, okay.  The full conversion is gonna span several devel cycles
anyway.  I'll re-convert ibmvstgt when the dust settles down.

Thank you.

--
tejun

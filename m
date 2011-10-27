From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between
 runtime PM and system sleep (v2)
Date: Thu, 27 Oct 2011 15:54:20 +0200
Message-ID: <CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
References: <201106260054.20578.rjw@sisk.pl> <201106292329.04163.rjw@sisk.pl>
	<201106292334.24518.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <201106292334.24518.rjw@sisk.pl>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/linux-pm/>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

2011/6/29 Rafael J. Wysocki <rjw@sisk.pl>:

> One of the roles of the PM core is to prevent different PM callbacks
> executed for the same device object from racing with each other.
> Unfortunately, after commit e8665002477f0278f84f898145b1f141ba26ee26
> (PM: Allow pm_runtime_suspend() to succeed during system suspend)
> runtime PM callbacks may be executed concurrently with system
> suspend/resume callbacks for the same device.
(...)
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

A quick question: is there some specific reason why this patch should
not go into the 3.0.y stable releases? We are trying to produce
a runtime PM system of product quality based on 3.0.y and we've
already had to backport this patch ourselves to get things stable.

We have also backported:
PM: Introduce generic "noirq" callback routines for subsystems (v2)
PM / Runtime: Update documentation of interactions with system sleep
PM / Runtime: Add new helper function: pm_runtime_status_suspended()

And now it seems to be sufficient to get this thing going.

Yours,
Linus Walleij

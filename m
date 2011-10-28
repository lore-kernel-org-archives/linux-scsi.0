From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between
 runtime PM and system sleep (v2)
Date: Fri, 28 Oct 2011 22:00:01 +0200
Message-ID: <CACRpkdahSR0P-hSSJWqhouAn8KwdH-=Tsgg9K0sjeT_JAtDzVg@mail.gmail.com>
References: <201106260054.20578.rjw@sisk.pl> <201106292334.24518.rjw@sisk.pl>
	<CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
	<201110272206.35180.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <201110272206.35180.rjw@sisk.pl>
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
Cc: Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Ulf Hansson <Ulf.Hansson@stericsson.com>, Tejun Heo <tj@kernel.org>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 27, 2011 at 10:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>> We are trying to produce
>> a runtime PM system of product quality based on 3.0.y and we've
>> already had to backport this patch ourselves to get things stable.
>>
>> We have also backported:
>> PM: Introduce generic "noirq" callback routines for subsystems (v2)
>> PM / Runtime: Update documentation of interactions with system sleep
>> PM / Runtime: Add new helper function: pm_runtime_status_suspended()
>>
>> And now it seems to be sufficient to get this thing going.
>
> Well, it isn't a simple fix and it changes the code's behavior quite
> significantly, so I thought it might not be a good idea to risk problems
> with -stable because of it. =A0Perhaps let's see how it works out in 3.1
> and backport it later if there are no problem reports related to it?

OK no hurries, let's give it a spin in 3.1 for some weeks or so.

Yours,
Linus Walleij

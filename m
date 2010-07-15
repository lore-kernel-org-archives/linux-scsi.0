From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 01:36:19 -0700
Message-ID: <20100715013619.ba473d39.akpm@linux-foundation.org>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
	<20100715035230.GA2186@suse.de>
	<AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Sender: alsa-devel-bounces@alsa-project.org
Errors-To: alsa-devel-bounces@alsa-project.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>, Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, Stephen@alsa-project.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hemminger <shemminger@vyatta.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 15 Jul 2010 10:31:15 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Thu, Jul 15, 2010 at 05:52, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Jul 14, 2010 at 04:38:52PM -0700, Andrew Morton wrote:
> 
> >> and the box still won't boot.
> >
> > Ick, that sucks.
> >
> > What kernel was FC6 based on originally?
> >
> > Kay, I thought that Fedora had fixed the "can't find root" issue for
> > this type of sysfs configuation a long time ago. __Or was that something
> > else for PPC that I am thinking of?
> 
> It was fixed, and it's weird bug in nash.
> 
> If Andrew is still doing the same thing as years ago, he does not
> update the initramfs image, he boots with the old original initramfs
> along with the new kernel. :)

I run

	VERS=$(make kernelrelease 2>/dev/null)
	<copy vmlinux>
	/sbin/new-kernel-pkg --mkinitrd --install 

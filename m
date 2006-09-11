From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/2] cciss: version update, new hw
Date: Mon, 11 Sep 2006 15:31:40 -0700
Message-ID: <20060911153140.3f2433a9.akpm@osdl.org>
References: <20060911213126.GA6867@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932175AbWIKWe6@vger.kernel.org>
In-Reply-To: <20060911213126.GA6867@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vgter.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Sep 2006 16:31:26 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> This patch adds support for new hardware and bumps the version to 3.6.10. It
> seems there were several changes introduced including soft_irq. I decided
> to bump the major number to reflect these changes. Since we're still 
> supporting older vendor kernels I need some way differenciate between kernel
> versions <=2.6.10 and newer kernels >=2.6.16. 
> I hate to send this in -rc6 but it seems like 2.6.18 is having a tough time
> getting out the gate. Please consider this for inclusion.

Adding a new device ID is a bit of a no-brainer - in fact bumping the
version number seems more risky than adding a device ID.

I'd be OK with a 2.6.18 merge, and shall send it into Linus unless Jens
nacks it, or gets there first.

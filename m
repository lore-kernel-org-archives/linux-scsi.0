From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.0+ merge window
Date: Mon, 11 Mar 2019 11:47:41 -0700
Message-ID: <CA+8MBb+MJhS9ejWQ0+vjDyhdnK5bsuaLPwpM5f-h1-6tHr4rVg@mail.gmail.com>
References: <1551940186.8289.60.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551940186.8289.60.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 6, 2019 at 10:30 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Hannes Reinecke (4):
>       scsi: kill command serial number

ia64 build error with arch/ia64/configs/sim_defconfig

arch/ia64/hp/sim/simscsi.c: In function 'simscsi_interrupt':
arch/ia64/hp/sim/simscsi.c:108:51: error: 'struct scsi_cmnd' has no
member named 'serial_number'

-Tony

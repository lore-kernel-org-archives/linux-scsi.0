From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: Re: HP G6 hardware kernel boot issue > 2.6.37 cciss/hpsa
Date: Tue, 08 Mar 2011 11:29:26 +0100
Message-ID: <1299580166.11985.11.camel@firesoul.comx.local>
References: <1299087769.4279.27.camel@firesoul.comx.local>
	 <20110303124705.GA19471@stro.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110303124705.GA19471@stro.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Maximilian Attems <max@stro.at>
Cc: Michael Prokop <mika@debian.org>, Marco d'Itri <md@linux.it>, Debian kernel team <debian-kernel@lists.debian.org>, Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Martin Pitt <martin.pitt@ubuntu.com>, Eric Dumazet <eric.dumazet@gmail.com>
List-Id: linux-scsi@vger.kernel.org


On Thu, 2011-03-03 at 13:47 +0100, Maximilian Attems wrote:
> On Wed, 02 Mar 2011, Jesper Dangaard Brouer wrote:
> 
[...]
> please file proper Debian bug report with reportbug.
> we already have scripts dealing with such device changes.
> Had previously thought that the need of them was over after the
> libata change, but obviously you show the contrare.
> 
> So fire up reportbug and report against linux-2.6 with severity grave.

I finally succeeded filing a Debian bug-report (as Debians mail system
clamav kept categorizing me as malware... hmm)

 Debian bug number: 617256
 Link: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=617256
 Update the case via email: 617256@bugs.debian.org

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network Kernel Developer
  Cand. Scient Datalog / MSc.CS
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer


[...]
> > Keywords: driver CCISS, HPSA, HP DL G6, uuid, udev, mkinitramfs,
> > initramfs-tools, debian squeeze
More keywords:
 HP Smart Array P410i Controller / Smart Array G6 controllers
 /dev/cciss/ scsi

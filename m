From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 3/3] faster workaround
Date: Thu, 11 Oct 2007 16:39:37 +0200
Message-ID: <200710111639.38240.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <20071011142628.48272a4a@the-village.bc.nu> <470E30F9.5060705@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <470E30F9.5060705@garzik.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 11 October 2007 16:19:37 Jeff Garzik wrote:
> 1) Just about the only valid optimization is to ensure that only the
> write path must be limited to small chunks, not both read- and
> write-paths.  Tejun had a patch to do this a long time ago, but it's an
> open question whether the large amount of code is worth it for a rare
> combination.

How large? This patch is rather small? Where can I find it?

>
> 2) Once we identified, over time, the set of drives affected by this
> 3112 quirk (aka drives that didn't fully comply to SATA spec), the
> debugging of corruption cases largely shifted to the standard routine:
> update the BIOS, replace the cables/RAM/power/mainboard/slot/etc. to be
> certain of problem location.

Replace this disk or the sata controller maybe, but usually people don't want 
to replace a big cluster, even if it is already 3 years old, this has to wait 
at least another 3 years.

The problem came up, when 200GB drives were replaced by *newer* 250GB drives 
(well maybe not the newest, no idea were they came from).

Anyway, I'm testing for more than 24h already and didn't observe any data 
corruption as without the patch. I know this is only an obersavation and no 
definite prove...
Also, this is with 3114, maybe this chip behaves a bit different than 3112?

Thanks,
Bernd



-- 
Bernd Schubert
Q-Leap Networks GmbH

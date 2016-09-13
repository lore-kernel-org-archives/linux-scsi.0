From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Tue, 13 Sep 2016 14:45:14 -0300
Message-ID: <20160913174514.GA3484@khazad-dum.debian.net>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 12 Sep 2016, Jason A. Donenfeld wrote:
> I was wondering if it'd be possible to have the uas driver -- or
> perhaps somewhere else in the stack -- fall back to using
> ATA-passthrough-TRIM for UNMAP, so that discard can work properly.
> AFAIK, the Windows drivers do exactly this.
> 
> If the answer is, "yes we want this! but we don't have the man power,"
> please tell me where I can start looking, so that I can submit the
> patch myself.

Whomever implements this, please add a "chicken bit" to allow the user
to disable it if the enclosure misbehaves.

-- 
  Henrique Holschuh

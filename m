From: Luben Tuikov <luben@splentec.com>
Subject: Re: inquiry in scsi_scan.c
Date: Sun, 05 Jan 2003 17:05:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E18AC42.4090107@splentec.com>
References: <UTC200301052135.h05LZ3725302.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <UTC200301052135.h05LZ3725302.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net

Andries.Brouwer@cwi.nl wrote:
> 
> There are at least four replies:
> 
> The factual: It seems you are unaware of the present USB storage code.
> For many devices the INQUIRY response is entirely fabricated.

I'm aware of this, but you were complaining of a new device
which you got, so I assumed the INQUIRY response data came
from the device, in your particular situation.
 
> The vicious circle: The SCSI blacklist works by attaching quirks
> to vendor and model data. This fails when the quirk is precisely
> that vendor and model data are not reported.

I agree with this.
 
> The theoretical: USB-storage is the SCSI host - it is responsible
> for presenting the SCSI layer with a device that complies with the
> SCSI standard. If any blacklisting is to be done it must be
> blacklisting in the USB storage code, not in the SCSI code.
> (And that blacklist exists, of course - it is called unusual_devs.h.)

I'm aware of this list.
 
> The practical: USB devices are notoriously bad as far as standard
> compliance is concerned. If it works with Windows that is good
> enough. That standard, too expensive to implement it all, or,
> after implementing, to test it all.
> Your philosophy leads to blacklisting almost every USB storage device
> (I possess a dozen or so, not a single one without quirks).
> 
> Of course that is a possibility: describe for every device on the market
> in what ways it fails. But it is counterproductive. When people buy
> a new device it would be nice if it worked with Linux immediately,
> not first after adding its quirks to some list. Indeed, several times
> a week I read someone reporting "add this to unusual_devs.h to make
> this device work". No doubt thousands of people just decide that their
> device does not work with Linux. In cases where it is possible to
> automatically detect and correct faulty data no list of quirks is
> required, and more devices will work with Linux out-of-the-box.
> 

Yes, I did understand all this from your first email -- the practicallity
of the matter. This is good.

I was just speaking out of principle, to present the other side.
Sometimes it's better to present a fix out of principle rather than
a particuliarity, this abstractizes further up and provides a long
lasting solution.

But yes, this is a pickle of a problem.

-- 
Luben



From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: libata / scsi separation
Date: Wed, 10 Dec 2008 09:01:18 -0700
Message-ID: <20081210160118.GX25548@parisc-linux.org>
References: <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain> <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com> <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com> <493F2DA9.7040008@gmail.com> <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com> <493F3B33.8010607@gmail.com> <20081210152445.GW25548@parisc-linux.org> <493FE15C.4060907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <493FE15C.4060907@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Grant Grundler <grundler@google.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 11, 2008 at 12:33:48AM +0900, Tejun Heo wrote:
> And yeap we definitely should try to do that too but I don't think
> RW_SG would be as useless as jumbo frames (much less compatibility
> problem and no loss of functionality), and the actual hardware
> overhead of issuing separate commands for each 4k segment is way
> higher than anything we do along the block and low level driver layers
> in terms of IO access, host bus and ATA (or SAS) bus overhead.

You're probably right that there's high overhead at the hardware level,
and we can't do anything about that.  There is some evidence that Linux
is the limiting factor in SSD performance right now due to not being
able to get enough commands to the device.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

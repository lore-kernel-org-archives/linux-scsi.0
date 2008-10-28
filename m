From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: Re: [PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 28 Oct 2008 17:02:40 +1100
Message-ID: <65a6ef750810272302x3f8f588dw9c4be85db4b55889@mail.gmail.com>
References: <65a6ef750810222008o139600e3o8d7c7cf50a4e4ea0@mail.gmail.com>
	 <49068DAC.605@garzik.org>
	 <65a6ef750810272255n4a082c8ep8e305e9e3bd8fc18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <65a6ef750810272255n4a082c8ep8e305e9e3bd8fc18@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mikpe@it.uu.se, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 28, 2008 at 4:55 PM, Mark Nelson <mdnelson8@gmail.com> wrote:
>>> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
>>> ---
>>>  drivers/ata/ahci.c |    3 +++
>>>  1 file changed, 3 insertions(+)
>>
>> applied
>
> Thanks Jeff!
>
> Feel free ignore the v2 I just sent out - it seems like the 0x3f19 cards
> never made it out into the wild (or if anyone think it's worth it, I could send
> an incremental patch that applies on top of this one)...
>
I just saw your pull request. It's probably better to wait to see if anybody
actually has any cards with the 0x3f19 on there.

Sorry for any confusion.

Thanks!

Mark

From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216 (was Re: [PATCH 0/2] Experimental Amiga Zorro ESP driver)
Date: Fri, 27 Sep 2013 01:50:19 +1200
Message-ID: <4d181bcc49b68321e8a1e16f2783fb19@gmail.com>
References: <1370552199-15048-1-git-send-email-schmitz@debian.org> <520D4AE3.6040801@aalto.fi> <520E76FC.9040803@aalto.fi> <11425cb5ec432e2fbb7b675052e8b33d@gmail.com> <520F5F81.7090409@aalto.fi> <52102BEC.7000006@gmail.com> <CAMuHMdV9vP-Qg2my5fyT+pa_WcDfZAPx5T1-4kXP8eD1oL8Kog@mail.gmail.com> <52108CAF.1010700@gmail.com> <CAMuHMdWqNBjHKiDojPdjzuOV65QXzjeMX5VbtUvgU7VTP4iYFg@mail.gmail.com> <5211DBD8.5090801@gmail.com> <5212840A.4080300@aalto.fi> <1ef2d87e4efecb2d8c8c2eaf8ac5fd51@gmail.com> <52133E48.50501@aalto.fi> <CAOmrzkKtB4OpnFNFh9PR4V8bc3ExfFXpwtkhGj0veQ4w-d=cqA@mail.gmail.com> <522F8B67.2080603@aalto.fi> <CAOmrzkKP4YcvnHcrtucMvS9WSaeg+6-qnobOWN6hBK=wkUHemg@mail.gmail.com> <CAMuHMdUH=9sv-Vb3ZTAGyfvEQOO0x0x1cUYhfd7040k8d+bSYg@mail.gmail.com> <5231DF69.6070807@aalto.fi>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <5231DF69.6070807@aalto.fi>
Sender: linux-m68k-owner@vger.kernel.org
To: Tuomas Vainikka <tuomas.vainikka@aalto.fi>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tuomas,

I might still have a copy of the manual somewhere from way back, if you 
haven't found it anywhere. Would be on an old disk or even hardcopy in 
storage, so please confirm you still need it.

Cheers,

  Michael



Am 13.09.2013 um 03:36 schrieb Tuomas Vainikka:

> On 09/11/2013 05:48 PM, Geert Uytterhoeven wrote:
>> On Wed, Sep 11, 2013 at 12:12 PM, Michael Schmitz 
>> <schmitzmic@gmail.com> wrote:
>>>> problem. Using PIO, only the first byte of the tag message comes 
>>>> through. It
>>>> might not be esp_scsi's fault, but there seems to be an assumption 
>>>> that all
>>>> devices support TCQ. Also, no SCSI-2 features seem to be enabled in 
>>>> the chip
>>>> by esp_scsi.
>>> I'd have to check with DaveM, but such an assumption might in fact 
>>> exist.
>> BTW, it would be nice to start CCing linux-scsi@vger.kernel.org and
>> David S. Miller <davem@davemloft.net> on future discussions.
>>
>> Gr{oetje,eeting}s,
>>
>>                          Geert
>>
>>
> Hello,
>
> Does anyone have the register descriptions for the FAS216 chip? It 
> would seem that receiving only one byte during reconnect is perfectly 
> normal [1] unless SCSI-2 features are explicitly enabled (which 
> esp_scsi doesn't seem to be doing).
>
> Also, looking at the timeout formulae in the old NCR53C9x.c driver, 
> the values would be different for FAS216. Why was this dropped from 
> the modern esp_scsi?
>
> 1. Page 2 in 
> http://www.datasheetarchive.com/dl/Scans-030/ScansU9X12569.pdf
>
> -Tuomas

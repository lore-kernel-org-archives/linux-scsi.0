From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] scsi: scsi_devinfo.c: Cleaning up unnecessarily
 complicated in conjunction with strncpy
Date: Mon, 15 Sep 2014 22:47:07 +0200
Message-ID: <CAFo99gYiSViTkek8uv_vBHyxG47An+giKuCS7SPR3FwGK1_SAw@mail.gmail.com>
References: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <94D0CD8314A33A4D9D801C0FE68B402958C7A75B@G9W0745.americas.hpqcorp.net>
 <CAFo99gbtGfEgcWukEQoEmcTro__aGND6-4bb4Ms+cV8Wu1FM4w@mail.gmail.com> <94D0CD8314A33A4D9D801C0FE68B402958C7A8A6@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C7A8A6@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2014-09-15 0:38 GMT+02:00 Elliott, Robert (Server Storage) <Elliott@hp.com>:
>
>
>> -----Original Message-----
>> From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
>> How do you mean?
>>
>> strncpy zeroes throughout the remainder of the string "from" until the
>> length off to_length, or otherwise guaranteed trailing zero characters
>> and a warning is printed.
>>
>> Is not it exactly the functionality that is desired?
>
> Ah, I see that in man 3 strcpy:
>     "If the length of src is less than n, strncpy() pads the
>      remainder of dest with null bytes."
>
> I agree that should work.
>
> ---
> Rob Elliott    HP Server Storage


Hi

Okay, good.
Suspected that there was some misunderstanding :)

Kind regards
Rickard Strandqvist

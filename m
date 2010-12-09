From: Jing Huang <huangj@Brocade.COM>
Subject: RE: linux-next: Tree for December 9
Date: Thu, 9 Dec 2010 11:35:42 -0800
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CFCB9049@HQ1-EXCH01.corp.brocade.com>
References: <20101209154148.ca4ba4e0.sfr@canb.auug.org.au>
	<AANLkTikjGhkYoR_o3uq-sUEY1daXSRWQgRmMBoVJ-n1=@mail.gmail.com>
	<20101209154900.GA20190@suse.de>
 <AANLkTimh-E2By3YdeapZ-HP-H8+Y+PWkt762zjH0sOEG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <AANLkTimh-E2By3YdeapZ-HP-H8+Y+PWkt762zjH0sOEG@mail.gmail.com>
Content-Language: en-US
Sender: linux-next-owner@vger.kernel.org
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>, Greg KH <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>
List-Id: linux-scsi@vger.kernel.org

>2010/12/9 Greg KH <gregkh@suse.de>:
>> On Thu, Dec 09, 2010 at 12:46:19PM +0100, Zimny Lech wrote:
>>> Ave
>>>
>>> 2010/12/9 Stephen Rothwell <sfr@canb.auug.org.au>:
>>> > Hi all,
>>> >
>>> > Changes since 20101208:
>>> >
>>>
>>> =A0 LD =A0 =A0 =A0drivers/built-in.o
>>> drivers/staging/built-in.o:(.data+0xec80): multiple definition of `=
log_level'
>>
>> That's coming from the cxt1e1 driver, I'll fix that up to be a "sane=
"
>> global name.
>>
>>> drivers/scsi/built-in.o:(.data+0xa71c): first defined here
>>
>> That's coming from the drivers/scsi/bfa/ driver, and it too should b=
e
>> fixed as it shouldn't have a global variable with this name in it.
>> Care to let the maintainer of that driver know about this as well?
>

Hi Zimny,=20

I will provide a fix for linux-next soon.
Thanks
Jing

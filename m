From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/3] cciss: bug fix for hpacucli
Date: Mon, 21 Nov 2005 18:45:29 +0100
Message-ID: <20051121174529.GJ15804@suse.de>
References: <20051118163357.GA10928@beardog.cca.cpqcorp.net> <20051118204946.GB25454@suse.de> <20051121082810.GV25454@suse.de> <20051121164648.GA7714@beardog.cca.cpqcorp.net> <438205EC.9040906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932407AbVKURoX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <438205EC.9040906@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mikem <mikem@beardog.cca.cpqcorp.net>, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sitniko@infonet.ee
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 21 2005, H. Peter Anvin wrote:
> mikem wrote:
> >>
> >>This sort-of makes it work. I get some complaints about unaligned access
> >>when setting up a test array:
> >>
> >>=> controller slot=0 create type=logicaldrive drives=all raid=1 
> >>drivetype=sas
> >>.hpacucli(12458): unaligned access to 0x60000fffffcb370e, 
> >>ip=0x40000000003c8550
> >>=> controller slot=0 create type=logicaldrive drives=all raid=1 
> >>drivetype=sata
> >>.hpacucli(12458): unaligned access to 0x60000fffffcb4aee, 
> >>ip=0x40000000003c8550
> >>.hpacucli(12458): unaligned access to 0x60000fffffcb370e, 
> >>ip=0x40000000003c8550
> >>.hpacucli(12458): unaligned access to 0x60000fffffcb370e, 
> >>ip=0x40000000003c8550
> >
> >This seems to be coming out of user space. We'll work with the application
> >folks to investigate. There is a library called infomanager that's used
> >by the app. There may be an issue there. Call you strace the program and
> >send me the results? I haven't seen this in my lab with a vendor kernel.
> >
> 
> What machine is this for?  For x86-64, the above are non-canonical 
> addresses.  IA64?

Yup, ia64.

-- 
Jens Axboe

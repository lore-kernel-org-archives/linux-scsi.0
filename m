From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] cciss: bug fix for hpacucli
Date: Mon, 21 Nov 2005 09:37:48 -0800
Message-ID: <438205EC.9040906@zytor.com>
References: <20051118163357.GA10928@beardog.cca.cpqcorp.net> <20051118204946.GB25454@suse.de> <20051121082810.GV25454@suse.de> <20051121164648.GA7714@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([192.83.249.54]:14034 "EHLO
	terminus.zytor.com") by vger.kernel.org with ESMTP id S932400AbVKURkW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 12:40:22 -0500
In-Reply-To: <20051121164648.GA7714@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <axboe@suse.de>, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sitniko@infonet.ee

mikem wrote:
>>
>>This sort-of makes it work. I get some complaints about unaligned access
>>when setting up a test array:
>>
>>=> controller slot=0 create type=logicaldrive drives=all raid=1 drivetype=sas
>>.hpacucli(12458): unaligned access to 0x60000fffffcb370e, ip=0x40000000003c8550
>>=> controller slot=0 create type=logicaldrive drives=all raid=1 drivetype=sata
>>.hpacucli(12458): unaligned access to 0x60000fffffcb4aee, ip=0x40000000003c8550
>>.hpacucli(12458): unaligned access to 0x60000fffffcb370e, ip=0x40000000003c8550
>>.hpacucli(12458): unaligned access to 0x60000fffffcb370e, ip=0x40000000003c8550
> 
> This seems to be coming out of user space. We'll work with the application
> folks to investigate. There is a library called infomanager that's used
> by the app. There may be an issue there. Call you strace the program and
> send me the results? I haven't seen this in my lab with a vendor kernel.
> 

What machine is this for?  For x86-64, the above are non-canonical 
addresses.  IA64?

	-hpa

From: "Ken Bass" <kbass@kenbass.com>
Subject: Re: 2.6 tape device i/o error
Date: Thu, 10 Jun 2004 19:15:04 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <62712.65.172.177.78.1086909304.squirrel@65.172.177.78>
References: <1048.65.172.177.78.1086906305.squirrel@65.172.177.78>
    <20040610223119.GI24864@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vroc.org ([216.127.139.4]:42249 "EHLO nomad.vroc.org")
	by vger.kernel.org with ESMTP id S263295AbUFJXPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 19:15:08 -0400
In-Reply-To: <20040610223119.GI24864@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <willy@debian.org>

> On Thu, Jun 10, 2004 at 06:25:05PM -0400, kbass@kenbass.com wrote:
>> Under 2.4 I have code the does:
>> fd = open("/dev/st0", RDONLY)
>> This always returns success.
>>
>> Under this new 2.6.4 (SMP) (plus alot of other changes) this same device
>> open hangs for 1-2 minutes and returns I/O error IF THERE IS NO TAPE in
>> the drive. If a tape is present, no problem.
>
> Try adding O_NONBLOCK.  Just a guess.

 You're guess is correct. I looked in st_open and someone added code from
2.4 to 2.6 that changes the semantics. I see this is documented in
Documentation/scsi/st.txt

  Thanks


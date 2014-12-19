From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: Fixes for AllRegistrants reservation
 handling
Date: Fri, 19 Dec 2014 00:21:59 -0800
Message-ID: <1418977319.29647.64.camel@haakon3.risingtidesystems.com>
References: <20141218145401.GD2476@iliastsi-m.arr>
	 <5493069B.3060701@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5493069B.3060701@interlog.com>
Sender: target-devel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Ilias Tsitsimpis <iliastsi@arrikto.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Motin <mav@FreeBSD.org>
List-Id: linux-scsi@vger.kernel.org

Hi Doug,

On Thu, 2014-12-18 at 11:53 -0500, Douglas Gilbert wrote:

<SNIP>

> 
> FreeNAS's iSCSI target also implements ODX which is one
> reason why I have been looking at it (hint to NAB). With
> ODX it does cut one significant corner in only supporting
> "access upon reference" RODs. Its ODX implementation found
> several bugs and holes in my ddpt ODX client code. 

So ODX support is still low on my current TODO list, but I'm happy to
assist anyone in the short-term who is willing to submit patches for
implementing the first steps to get the ball rolling.  IIRC, the CDB
emulation additions are really quite straight-forward, especially given
you've already got a working ddpt client.  ;)

Of course, the more interesting question is once EXTENDED_COPY(LID4)
emulation is in place, how is the interface for supporting tokenized
READ/WRITE through to struct block_device (and FILEIO too) going to
look..?

I haven't seen much discussion on this topic, and would be interested to
hear if anyone has thoughts on how that piece might work.

--nab

From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding directly
 to prep
Date: Mon, 05 Jul 2010 17:54:43 -0400
Message-ID: <4C3254A3.6080709@teksavvy.com>
References: <1277917264.2839.153.camel@mulgrave.site> <20100701104653O.fujita.tomonori@lab.ntt.co.jp> <20100702110343.GA27159@lst.de> <20100705160023S.fujita.tomonori@lab.ntt.co.jp> <20100705192413.GA24189@lst.de> <4C3253C0.8040900@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C3253C0.8040900@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> On 05/07/10 03:24 PM, Christoph Hellwig wrote:
>>
>> What codebase were you testing on? Sorry, but curently I'm a bit lost
>> in the maze of patches. I've got both and intel and an OCZ SSD
..

Do you, or anyone else with one, know what the upper limit is on
TRIM operations with the Intel SSDs ?

I need to know the maximum amount of TRIM ranges they will process
in a single command.

Eg. Indilinx-based SSDs don't appear to have a limit -- they'll accept
a TRIM command with thousands of LBA ranges included.

Sandforce-based SSDs appear to restrict things to max 4KB of range data.

So.. what about Intel?

Thanks

  

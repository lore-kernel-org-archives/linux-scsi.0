From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH, RFC] MAINTAINERS: update OSD entries
Date: Wed, 3 May 2017 13:08:28 +0300
Message-ID: <f3320b22-060f-2c57-77a9-513747a148f4@electrozaur.com>
References: <20170502075720.23570-1-hch@lst.de>
 <1493724812.2715.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1493724812.2715.1.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@lst.de>, bhalevy@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/02/2017 02:33 PM, Jeff Layton wrote:
> On Tue, 2017-05-02 at 09:57 +0200, Christoph Hellwig wrote:
>> The open-osd domain doesn't exist anymore, and mails to the list lead
>> to really annoying bounced that repeat every day.
>>
>> Also the primarydata address for Benny bounces, and while I have a new
>> one for him he doesn't seem to be maintaining the OSD code any more.
>>
>> Which beggs the question:  should we really leave the Supported status
>> in MAINTAINERS given that the code is barely maintained?
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  MAINTAINERS | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1bb06c5f7716..28dd83a1d9e2 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -9418,10 +9418,6 @@ F:	drivers/net/wireless/intersil/orinoco/
>>  
>>  OSD LIBRARY and FILESYSTEM
>>  M:	Boaz Harrosh <ooo@electrozaur.com>
>> -M:	Benny Halevy <bhalevy@primarydata.com>
>> -L:	osd-dev@open-osd.org
>> -W:	http://open-osd.org
>> -T:	git git://git.open-osd.org/open-osd.git
>>  S:	Maintained
>>  F:	drivers/scsi/osd/
>>  F:	include/scsi/osd_*
> 
> Hah, you beat me to it! I was going to spin up a patch for this today.
> 
> Acked-by: Jeff Layton <jlayton@redhat.com>

Acked-by: Boaz Harrosh <ooo@electrozaur.com>

> 

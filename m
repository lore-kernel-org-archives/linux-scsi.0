From: Allan Wind <allan_wind@lifeintegrity.com>
Subject: Re: LSISAS1068E + WDC WD2002FYPS: I/O error & Sense Key
Date: Fri, 31 Jul 2009 14:40:23 -0400
Message-ID: <20090731184023.GT3211@lifeintegrity.com>
References: <20090727060322.GB27002@lifeintegrity.com> <4A70A64A.2070605@gmail.com> <20090729200714.GA20706@lifeintegrity.com> <4A70D57B.6030301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A70D57B.6030301@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2009-07-29T17:04:27, Robert Hancock wrote:
> On 07/29/2009 02:07 PM, Allan Wind wrote:
>> On 2009-07-29T13:43:06, Robert Hancock wrote:
>>> On 07/27/2009 12:03 AM, Allan Wind wrote:
>>>> I have a pair of Western Digital RE4-GP (WD2002FYPS) in RAID1 configuration
>>>> using Linux 2.6.30.3 and seeing the following:
>>>>
>>>> [ 4907.485324] end_request: I/O error, dev sdb, sector 3907028974
>>> Are there no error messages before this point? Can you post the full
>>> dmesg output from bootup?
>>
>> Thanks for looking into this, Robert.  I do not see any relevant error
>> message before this point, but made the entire 82k dmesg available here:
>> http://lifeintegrity.com/~allan/dmesg
>
> It seems like some request failed but apparently that mptsas driver  
> isn't dumping out what happened for some reason. There are some of those  
> "recovered error" indications but they're not near the I/O error report,  
> so I'm not sure what's going on. CCing linux-scsi.

Is there any data I can help with to advance this issue?


/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>


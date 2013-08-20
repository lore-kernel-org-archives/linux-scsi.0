From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/9] target: Add support for COMPARE_AND_WRITE (VAAI)
 emulation
Date: Tue, 20 Aug 2013 18:01:19 -0400
Message-ID: <5213E72F.6070309@interlog.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>  <20130820212912.GA9483@lst.de> <1377035588.32763.7.camel@haakon3.risingtidesystems.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377035588.32763.7.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 13-08-20 05:53 PM, Nicholas A. Bellinger wrote:
> On Tue, 2013-08-20 at 23:29 +0200, Christoph Hellwig wrote:
>> On Tue, Aug 20, 2013 at 08:07:51PM +0000, Nicholas A. Bellinger wrote:
>>>
>>> It's also currently lacking the necessary sychronization between I/O
>>> submission of COMPARE_AND_WRITE verify instance and write instance
>>> user data, which is still being worked on in order to avoid additional
>>> overhead in the main I/O fast path.
>>
>> I don't think merging such a non-conforming implementation makes any sense.
>>
>
> Yes, I don't intend to merge anything that's not fully functional.
>
> The idea was to get review going on these pieces first.  I'll be posting
> an PATCH-v2 to complete the implementation over the next days.
>
>> Also for a complex command like this with all it's race potential I would
>> really like to see some test cases to go along with it.
>>
>
> Yes, Eric @ PureStorage has a sg_compare_write that I'm using to test
> this.  It's probably about time that this be included in upstream
> sg3-utils too..

Changelog for sg3_utils-1.35 [20130117] [svn: r476]
   - sg_compare_and_write: new utility
...

So it has been released for 6 months. Also version 1.36
has been released since then so you might check more
often. Does Eric's version have any improvements over the
version already in sg3_utils? [Apart from a shorter name ...]

Doug Gilbert

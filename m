From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] 2.5.x add back missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 09:45:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7A529C.5050607@torque.net>
References: <20030319184444.A9694@beaverton.ibm.com> <3E7A317A.702@splentec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Patrick Mansfield wrote:
> 
>> The change to use a pool for scsi_cmnd allocations removed some
>> scsi_queue_next_request calls, this patch restores the calls, and
>> exports scsi_put_command and scsi_get_command.
> 
> 
> And there was a point to this removal.  I did mention it on linux-scsi.
> 
> Look, don't try to make the code look as it did *before* -- there's
> always a point to a change -- I think I mentioned exactly this
> before on linux-scsi...
<snip/>

Luben,
 From my own experience, I know that some patches have a
negative impact. If that is done by someone else in a driver
that I maintain then the bug reports (almost always polite)
come to me. In most cases it means modifying the original
patch to stop "collateral damage".

If you don't like what Patrick is proposing, please explain
why. [Rather than re-explain, you could supply a url to the
prior post in the marc.theaimsgroup.com archive.] I don't
think boldface exclamations are required.
Naturally you are at liberty to present another patch which
merges what you are trying to do with Patrick's work.

Doug Gilbert


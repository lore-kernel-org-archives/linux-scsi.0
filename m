From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
Date: Wed, 18 Aug 2010 12:28:32 -0400
Message-ID: <4C6C0A30.1070008@scalableinformatics.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com> <1282144271.3035.31.camel@mulgrave.site>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282144271.3035.31.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:

>> During the open panel, my question was really specific - 
>>
>> Q) What is the future of a SCSI-target subsystem in linux. Which 
>>    target engine/subsystem can we expect?
>>
>> Your answer) There is place for only 1 target-subsystem in the Linux
>> scsi stack and in the LSF summit the decision was taken to merge LIO.
>> Has that
>> decision changed since the summit?
> 
> The decision hasn't been taken to merge LIO, but based on what happened
> at the summit, I think it's the most viable candidate and will likely be
> merged by 2.6.37

Quick question ... will LIO support SRP?  I should probably run over to 
their lists and ask, but a quick inspection of their site this morning 
shows that they are mostly iSCSI and FC focused.  (LIO folks, please 
feel free to step up and comment)

I'd certainly like to see a single framework, but not at the cost of 
losing important (to us) functionality.  We'd like to continue to use 
SRP, and iSCSI.  We'd like to use iSER (which is in the tgt stack) which 
LIO would give us when merged with tgt.  We are currently using SCST's 
iSCSI and SRP stack within our products.

I believe this also affects the OFED folks, as SRP is one of their 
services (based upon SCST).

Any guidance (in a general sense on the target side, not necessarily 
specific to LIO) on this would be appreciated.  SCST has been a good 
system for us to work with.  I'd hate to lose its functionality, and 
have us be forced to re-engineer some of our backend logic to work 
around the missing bits.  Thanks!

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

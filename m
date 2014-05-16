From: Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH 1/2] scsi: hyper-v storvsc switch up to SPC-3
Date: Fri, 16 May 2014 18:39:11 +0100
Message-ID: <53764D3F.3060008@mev.co.uk>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>	
 <1400254748-21573-2-git-send-email-abbotti@mev.co.uk>
 <1400260496.2221.44.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1400260496.2221.44.camel@dabdike.int.hansenpartnership.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, Andy Whitcroft <apw@canonical.com>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On 2014-05-16 18:14, James Bottomley wrote:
> On Fri, 2014-05-16 at 16:39 +0100, Ian Abbott wrote:
>> From: Andy Whitcroft <apw@canonical.com>
>>
>> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> That is my patch, isn't it, just with a slightly modified comment:
>
> http://marc.info/?l=linux-scsi&m=137908428211951

I believe so, yes.  Looking at Ubuntu's kernel repository, Andy reverted 
his original 4 patches and applied your patch instead.  I'm not sure 
about the other patch (PATCH 2/2) that disables the MAINTENANCE_IN 
command.  Perhaps that was needed as a consequence of claiming to be 
SCSI level SPC-3?

> Andy promised to go off and test it and that's where the thread ended. I
> take it the results of the testing was positive?  I was expecting him to
> report back on that so KY could ack the patch.
>
> James

The patch seems to be in Ubuntu Saucy's 3.11 kernel version 3.11.0-12.18 
onwards - see 
http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-saucy.git;a=log;h=refs/tags/Ubuntu-3.11.0-12.18 
for the logs.

Would you like me to resubmit the patch with you as the author?  There 
isn't a "Signed-off-by:" line for you on this patch at the moment.  Is 
it okay for me to add one?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

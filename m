From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Tue, 01 Nov 2011 19:13:16 -0600
Message-ID: <4EB0992C.5070309@gmail.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com> <1320126812.7701.17.camel@dabdike> <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/01/2011 12:35 AM, JiSheng Zhang wrote:
> Hi James,
>
> 2011/11/1 James Bottomley<James.Bottomley@hansenpartnership.com>:
>> On Tue, 2011-11-01 at 13:31 +0800, JiSheng Zhang wrote:
>>> Currently, there's no start/stop management in scsi cdrom driver to
>>> spin up/down the motor do we need to implement it?
>>
>> Say more ... like what you think it buys.  The auto spin down of a CD
>> tends to be the best power control we have and it's not even clear that
>> manufacturers have implemented any other useful power states.
>
> Does it mean the behavior depends on manufacturers? Some cd will spin
> down automatically? Even so, how about during shutdown just after reading
> something from cdrom?
>
> Thanks,
> Jisheng

I believe the main reason disks are stopped during shutdown is that for 
many hard drives that use head unloading, it's much better for the 
lifespan of the drive to do a powered head unload on software command 
before powering off than an emergency unload caused by a loss of power. 
I don't believe that optical drives have such an issue.

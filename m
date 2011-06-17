From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 11:41:24 -0400
Message-ID: <4DFB75A4.8070405@interlog.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave> <20110617052523.GB741@kroah.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110617052523.GB741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On 11-06-17 01:25 AM, Greg KH wrote:
> On Thu, Jun 16, 2011 at 04:31:29PM -0400, James Bottomley wrote:
>>> So again, I really don't like this, just fix the userspace tools to map
>>> the proper device name that the kernel is using to the userspace name
>>> the tool used, and all is fine.  This has been done already today,
>>> succesfully, by many of the big "enterprise" monitoring systems that
>>> work quite well on Linux, proving that this is not something that the
>>> kernel needs to provide to implement properly.
>>
>> Well, it's expediency.  Sure we could try to patch the world, but I
>> think the simple patch of getting the kernel to print a preferred name
>> solves 90% of the problem.  Sure there is a long tail of userspace
>> components that needs fixing, but that can be done gradually if we take
>> the kernel route.  If we go the userspace route, it will be a long while
>> before we even get to 50% coverage.
>
> I do not think that just because some people feel it is easier to change
> the kernel than change userspace tools, that we are somehow forced to
> accept their changes.
>
> As for "expediency", it has been a full year since the last time this
> was proposed.  All userspace tools that would need to be changed to
> implement this in userspace have had updates released for them in that
> year, and the changes needed to make to them could have been done
> already.

Could you elaborate taking one user space tool as an
example and tell us what changes you think should be
made?

Are you talking about low level tools such as hdparm,
smartmontools and mine or tools further up the "food
chain"?

Doug Gilbert

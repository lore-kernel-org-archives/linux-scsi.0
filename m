From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ANNOUNCE] multipath-tools-0.3.4
Date: Mon, 25 Oct 2004 20:39:35 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417CD7E7.40903@torque.net>
References: <1096071849.4466.31.camel@zezette>  <1097054573.4163b96d1262c@imp5-q.free.fr>  <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>  <1098269169.417641f18a234@imp1-q.free.fr>  <1098656088.9350.88.camel@zezette> <1098692559.2798.7.camel@laptop.fenrus.org> <1098697123.417cc9a3b5bc5@imp1-q.free.fr>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098697123.417cc9a3b5bc5@imp1-q.free.fr>
To: christophe.varoqui@free.fr
Cc: Arjan van de Ven <arjan@infradead.org>, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, patmans@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

christophe.varoqui@free.fr wrote:
> Selon Arjan van de Ven <arjan@infradead.org>:
> 
> 
>>On Mon, 2004-10-25 at 00:14 +0200, christophe varoqui wrote:
>>
>>
>>>	* multipath & multipathd now use the same path checkers.
>>>	  Consequence being multipath now need sg loaded
>>
>>why sg and not using SG_IO on the actual devices ?
>>mp-tools are 2.6 only anyway, right ?
>>
> 
> Glad you notice :)
> 
> In fact all the sg stuff I use is done with the SG_IO ioctl (see
> libcheckers/*.c)
> But somehow, it doesn't work as expected. I don't remember how exactly it failed
> in my tests but it did ... I remembered receiving bad path status and
> experiencing blocked checkers.
> 
> I would really like someone experienced put his nose in this stuff. If you want,
> I can code up a flag to switch the mp-tools ioctl submission between blockdev
> and sgdev.
> 
> Note you don't need to have real multipathed hardware to run and test the thing
> : parallel SCSI hw suffice and is seen as monopath.

A significant patch from Patrick Mansfield concerning the
error reporting of the block layer SG_IO ioctl is present
in lk 2.6.10-rc1 . It was not present in lk 2.6.9 and earlier.

Doug Gilbert


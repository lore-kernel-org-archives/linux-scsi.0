From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata update posted
Date: Sun, 14 Sep 2003 18:31:26 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F64EC3E.5040102@pobox.com>
References: <3F628DC7.3040308@pobox.com> <20030913211332.GC3478@werewolf.able.es> <20030913213828.GC21426@gtf.org> <20030914222736.GA29560@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030914222736.GA29560@carfax.org.uk>
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Cc: "J.A. Magallon" <jamagallon@able.es>, SCSI Mailing List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hugo Mills wrote:
> On Sat, Sep 13, 2003 at 05:38:28PM -0400, Jeff Garzik wrote:
> 
>>No user documentation, but feel free to ask me questions.  Here's a
>>quick overview:
>>
>>ata_piix, ata_via -- low-level driver modules
>>libata -- shared code module for the above
> 
> 
>    Do you have any plans to support SiI3112 in libata? The current
> SiI3112 drivers in the kernel just don't seem to work right on my
> hardware. :(


Yes!  It should be fairly quick to add Silicon Image SATA support, too.

It's all about finding the time to do it ;-)  Hopefully some time in the 
next week or two...

	Jeff




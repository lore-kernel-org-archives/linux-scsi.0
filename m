From: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>
Subject: Re: Re: fibre channel/multipath questions
Date: Tue, 30 Aug 2005 11:19:23 +0200
Message-ID: <200508301119.24072.Rik.Bobbaers@cc.kuleuven.be>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
	<20050829172316.GC7875@infradead.org>
	<1125378108.6375.15.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1125378108.6375.15.camel@zezette>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 30 August 2005 07:01, christophe varoqui wrote:
> On lun, 2005-08-29 at 18:23 +0100, Christoph Hellwig wrote:
> > I think you can setup dm-multipath based on WWNs, so the device
> > numbers don't matter.  Cc'ed the dm-devel list to verify my assumption.
>
> Yes, true for the multipathed devices, which leaves the problem intact
> for the local drives ...

There is no problem with multipath recognising different devices. Nor is there 
a problem with raid devices.
at boot these are all recognised, if they change, no problem at all...
situation we have:
local disks in raid1 (i'd prefer sda + sdb)
san disks are multipath (sdc and on...)
problem is: lilo.conf... i say: [r|b]oot=/dev/md0
raid-extra-boot="/dev/sda, /dev/sdb"

the last rule poses the problem. depending on how many multipath devices i 
have, i constantly have to change lilo.conf for every machine.

in bsd, there is a way to set your drives to a fixed name, is there something 
alike in linux? or a sollution to this problem? (i'm definately willing to 
help find one, if there isn't... and i guess i'm not the only one with this 
problem?)

thanks in advance all! (and sorry for the spamming)

-- 
harry
aka Rik Bobbaers

K.U.Leuven - LUDIT          -=- Tel: +32 485 52 71 50
Rik.Bobbaers@cc.kuleuven.be -=- http://harry.ulyssis.org

Disclaimer:
By sending an email to ANY of my addresses you are agreeing that:
  1. I am by definition, "the intended recipient"
  2. All information in the email is mine to do with as I see fit and make 
such financial profit, political mileage, or good joke as it lends itself to. 
In particular, I may quote it on usenet.
  3. I may take the contents as representing the views of your company.
  4. This overrides any disclaimer or statement of confidentiality that may be 
included on your message. 

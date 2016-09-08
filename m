From: James Bottomley <James.Bottomley@Hansenpartnership.com>
Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Thu, 08 Sep 2016 18:38:02 -0400
Message-ID: <ea9150f3-de17-4baf-b8f2-2fb1e8f9b990@email.android.com>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda> <146706367078.29152.14405582249219794335.stgit@brunhilda> <yq1a8ghoim3.fsf@sermon.lab.mkp.net> <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net> <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net> <1473359114.2781.38.camel@linux.vnet.ibm.com> <48C22F0C33E45A4F83E15DF49719341D38F495F6@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58558 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753174AbcIHWk5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2016 18:40:57 -0400
In-Reply-To: <48C22F0C33E45A4F83E15DF49719341D38F495F6@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott Benesh <scott.benesh@microsemi.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On September 8, 2016 2:33:52 PM EDT, Scott Benesh <scott.benesh@microsemi.com> wrote:
>> 
>> On Thu, 2016-09-08 at 18:15 +0000, Don Brace wrote:
>> > > > -    { 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /*
>> > > > Adaptec PMC
>> > > > Series 9 */
>> > > >
>> > > > How are people that load aacraid in their initrd going to boot
>> > > > after this?
>> > > >
>> > > > --
>> > > > Martin K. Petersen      Oracle Linux Engineering
>> > >
>> > > I updated smartpqi/Kconfig and added
>Documentation/scsi/smartpqi.txt
>> > > to inform users of the need to configure the smartpqi driver
>moving
>> > > forward for aacraid Series 9 controllers.
>> > >
>> > > Hope this helps.
>> 
>> That's not going to be enough: this ID has been in the aacriad driver
>since
>> 2011.  That means anyone who finally gets hold of one of these new
>cards
>> but uses a distro that doesn't have the new smartpqi driver will be
>attached
>> via the aacraid one.
>> 
>
>That's ok because for previous distros the new controller will work
>with the previous aacraid driver, although with non-optimal
>performance.

Not after this change hits. Then systems that only have aacraid in the initrd will fail to boot.

>What we want to do is sync up at 4.9 so going forward only the new
>smartpqi driver will attach to these new controllers.

So you have a plan in place with the distros to migrate the initrd images? Without being told, some will only install the modules the previous initrd  was configured for.

James

>Scott
>
>> Given that the life times of enterprise distributions is two years
>and you're
>> releasing this smartpqi soon, the overlap is unavoidable.
>> 
>> James
>> 


-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.

From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Fri, 14 Oct 2016 10:41:46 -0500
Message-ID: <87b601b5-87c4-cbce-dea6-69cc5df2e218@microsemi.com>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
 <146706367078.29152.14405582249219794335.stgit@brunhilda>
 <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
 <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
 <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net>
 <1473359114.2781.38.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33477 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbcJNPlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 11:41:49 -0400
Received: by mail-pf0-f196.google.com with SMTP id i85so4064461pfa.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2016 08:41:49 -0700 (PDT)
In-Reply-To: <1473359114.2781.38.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/08/2016 01:25 PM, James Bottomley wrote:
> On Thu, 2016-09-08 at 18:15 +0000, Don Brace wrote:
>>>> -    { 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /*
>>>> Adaptec PMC
>>>> Series 9 */
>>>>
>>>> How are people that load aacraid in their initrd going to boot
>>>> after
>>>> this?
>>>>
>>>> --
>>>> Martin K. Petersen      Oracle Linux Engineering
>>> I updated smartpqi/Kconfig and added
>>> Documentation/scsi/smartpqi.txt to
>>> inform users of the
>>> need to configure the smartpqi driver moving forward for aacraid
>>> Series 9
>>> controllers.
>>>
>>> Hope this helps.
> That's not going to be enough: this ID has been in the aacriad driver
> since 2011.  That means anyone who finally gets hold of one of these
> new cards but uses a distro that doesn't have the new smartpqi driver
> will be attached via the aacraid one.
>
> Given that the life times of enterprise distributions is two years and
> you're releasing this smartpqi soon, the overlap is unavoidable.
>
> James
>
We can make sure that we mention the need to enable the smartpqi
driver in the documentation provided/posted for these new controllers
otherwise the aacraid driver will not be able to fully support the new
controller features.

Don
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


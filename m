From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: Re: adaptec 2120S software under RedHat 8.0 and FC2
Date: Tue, 22 Mar 2005 16:32:04 -0000 (GMT)
Message-ID: <3423.137.195.14.2.1111509124.squirrel@www.macs.hw.ac.uk>
References: <60807403EABEB443939A5A7AA8A7458BED25F7@otce2k01.adaptec.com>
    <20050320091251.GB12000@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from izanagi.macs.hw.ac.uk ([137.195.13.5]:46272 "EHLO
	izanagi.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S261406AbVCVQcU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 11:32:20 -0500
In-Reply-To: <20050320091251.GB12000@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, matt_domsch@dell.com


Christoph Hellwig said:
> On Thu, Mar 17, 2005 at 08:41:18AM -0500, Salyzyn, Mark wrote:
>> We are pressuring our management application folks to switch to /sys as
>> well, has not happened yet. In part because changes have to work for all
>> tested releases and operating systems, our testing department only test
>> distributions in the requirement documents, fixes are only approved if
>> they affect current testing, certification testing requires a driver
>> that can be fixed and not errata'd and thus typically can not be in-box,
>> CONFIG_PROC_FS being on in all distributions and the need to keep the
>> /proc interface alive to permit the current and legacy applications in
>> test the ability to continue to function.
>
> We're not going to add new procfs handler for scsi HBA drivers.
>
> Unfortunately this problems shows once more that Adaptec managment doesn't
> care the slightest bit for Linux and has the worst support of all RAID /
> Storage vendors.  I can only advise OEMs and customers to stay far away
> from Adaptec equipment if they want to use Linux.

Since you advise us to stay away from Adaptec, and I assume you are part
of the team that manages the Fedora system, can you advise users what RAID
/ Storage vendors to use? ie what quality vendors support Linux?
Thanks,

Ross

>


-- 
Ross Macintyre (raz@macs.hw.ac.uk)

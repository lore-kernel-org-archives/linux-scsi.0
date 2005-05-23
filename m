From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Mon, 23 May 2005 15:12:02 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B0132B925@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:7913 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261939AbVEWTMF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 15:12:05 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
> On Mon, May 23, 2005 at 11:36:48AM -0700, Mark Haverkamp wrote:
>> > the "Adaptec Raid Controller:" doesn't belong in here.  The driver
build
>> > data and version neither, use MODULE_VERSION instead.
>> 
>> Using MODULE_VERSION in the snprinf doesn't seem to work:
>> 
>> drivers/scsi/aacraid/linit.c: In function `aac_show_host_version':
>> drivers/scsi/aacraid/linit.c:541: error: `MODULE_VERSION' undeclared
(first use in this function)
>
>sorry, MODULE_VERSION is a macro similar to MODULE_LICENSE or
>MODULE_AUTHOR.
>You say MODULE_VERSION("something"); outside any function and you can
find
>the version out using modinfo and sysfs (not sure the latter is
implemented
>yet, but there were patches floating around)

modinfo reports the binaries modules information. The sysfs version
would report the actual in-memory driver information. How do we make
sure the sysfs report of the MODULE_VERSION patch is driven home? :-)

Sadly, we can't access the string that was placed into the .modinfo
section (the name is a concatenation of the 'verison' with the line
number of the MODULE_VERSION 'call') from within the driver program for
use in the host_version function.

-- Mark Salyzyn

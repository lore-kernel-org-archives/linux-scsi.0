From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [osd-dev] [PATCH 01/18] major.h: char-major number for OSD device
 driver
Date: Wed, 26 Nov 2008 10:07:31 -0800
Message-ID: <492D9063.9090507@oracle.com>
References: <491073BB.4000900@panasas.com> <1225815420-5721-1-git-send-email-bharrosh@panasas.com> <492D8863.1000104@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080202060701020107080205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:30323 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKZSIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 13:08:34 -0500
In-Reply-To: <492D8863.1000104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: open-osd development <osd-dev@open-osd.org>, Torben Mathiasen <device@lanana.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>device@lanana.org, hpa@zytor.com

This is a multi-part message in MIME format.
--------------080202060701020107080205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Boaz Harrosh wrote:
> Boaz Harrosh wrote:
>> We need a major for a char device for our OSD device driver.
>> Attached is a proposed patch for the Documentation/devices.txt
>> and include/linux/major.h files.
>>
>> I have allocated the *260* char device as it looked like the next
>> available on the lanana.org web-site
>> (http://lanana.org/docs/device-list/devices-2.6+.txt)
>>
>> Any number will do. Please allocate a number for us
>>
>> (See http:/open-osd.org for further information)
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> CC: Torben Mathiasen <device@lanana.org>
> 
> Hi Torben Mathiasen
> 
> The maintainers file as well as the lanana.org website only states
> this <device@lanana.org> email address. I hope it is the right one.
> 
> Please you have not confirmed or revoked my ability to use 260 
> as a Major for a new char-device. Please review

Was it cc-ed to device@lanana.org?  I can't see that.  Adding it now.

John Cagle, can you comment on this, please?

And also have the attached patch merged into the MAINTAINERS file, please.

The www.lanana.org web page also needs to be updated:
  Maintained by Torben Mathiasen
is no longer correct.


> What git tree should this go through?
> 
> Thanks 
> Boaz
> 
>> ---
>>  Documentation/devices.txt |    6 ++++++
>>  include/linux/major.h     |    1 +
>>  2 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
>> index 05c8064..d18070b 100644
>> --- a/Documentation/devices.txt
>> +++ b/Documentation/devices.txt
>> @@ -3142,6 +3142,12 @@ Your cooperation is appreciated.
>>  		  1 = /dev/blockrom1	Second ROM card's translation layer interface
>>  		  ...
>>  
>> +260 char	OSD (Object-based-device) SCSI Device
>> +		  0 = /dev/osd0		First OSD Device
>> +		  1 = /dev/osd1		Second OSD Device
>> +		  ...
>> +		  255 = /dev/osd255	256th OSD Device
>> +
>>   ****	ADDITIONAL /dev DIRECTORY ENTRIES
>>  
>>  This section details additional entries that should or may exist in
>> diff --git a/include/linux/major.h b/include/linux/major.h
>> index 8824945..058ec15 100644
>> --- a/include/linux/major.h
>> +++ b/include/linux/major.h
>> @@ -171,5 +171,6 @@
>>  #define VIOTAPE_MAJOR		230
>>  
>>  #define BLOCK_EXT_MAJOR		259
>> +#define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
>>  
>>  #endif
> 


-- 
~Randy

--------------080202060701020107080205
Content-Type: text/x-patch;
 name="maint-update-lanana.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="maint-update-lanana.patch"

From: Randy Dunlap <randy.dunlap@oracle.com>

Update the DEVICE NUMBER REGISTRY (LANANA) maintainer entry.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20081126.orig/MAINTAINERS
+++ linux-next-20081126/MAINTAINERS
@@ -1372,7 +1372,7 @@ M:	Douglas_Warzecha@dell.com
 S:	Maintained
 
 DEVICE NUMBER REGISTRY
-P:	Torben Mathiasen
+P:	John Cagle
 M:	device@lanana.org
 W:	http://lanana.org/docs/device-list/index.html
 L:	linux-kernel@vger.kernel.org

--------------080202060701020107080205--

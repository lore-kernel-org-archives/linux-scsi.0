From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH for sg3_utils 0/4] Simplify the sg3_utils configure script
Date: Wed, 3 Jan 2018 09:12:39 -0500
Message-ID: <fd26ac48-81ee-f82e-c6a0-2718d5dd4484@interlog.com>
References: <0ecf9f85250f4269b98bd85c8c3592fa@SIWEX5A.sing.micron.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53983 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbeACOMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 09:12:47 -0500
In-Reply-To: <0ecf9f85250f4269b98bd85c8c3592fa@SIWEX5A.sing.micron.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 2018-01-03 04:37 AM, Bean Huo (beanhuo) wrote:
> Hi, Bart and Dong
> Do you think we need to submit all changed diff including some generated files by automake?
> Such as config.h.in, Makefile.in..., in fact, we only manually did a few modificaiton on
> Some files such as configura.ac,makefile.am.

Hi,
Yes, I only needed the configure.ac and Makefile.am changes from Bart.
Anyway, they are in my sg3_utils subversion rev 742 which should
appear soon on Hannes' site:
    https://github.com/hreinecke/sg3_utils

Currently it is at rev 741.

sgp_dd was also changed to only use pthread_kill() with the older code
"#if 0"-ed out just in case it needs to be revisited. The checking macros
for pthread_cancel() and pthread_kill() are still in configure.ac .

Doug Gilbert

>> The four patches in this series is what I came up with after having reviewed
>> the sg3_utils configure script. Please consider to apply these patches on the
>> sg3_utils trunk.
>>
>> Thanks,
>>
>> Bart.
>>
>> Bart Van Assche (4):
>>   configure.ac: Suppress an autoconf warning
>>   configure.ac: Only link with the pthread library if required
>>   configure.ac: Avoid code duplication
>>   configure.ac, Makefile.am: Use CFLAGS and LIBS instead of os_cflags
>>     and os_libs
>>
>> Makefile.in         |   3 +-
>> config.h.in         |   6 +-
>> configure           | 672 +++++++++++++++++++---------------------------------
>> configure.ac        |  83 +++----
>> doc/Makefile.in     |   3 +-
>> include/Makefile.in |   3 +-
>> lib/Makefile.am     |   2 +-
>> lib/Makefile.in     |   5 +-
>> scripts/Makefile.in |   3 +-
>> src/Makefile.am     | 140 ++++++-----
>> src/Makefile.in     | 145 ++++++------
>> 11 files changed, 425 insertions(+), 640 deletions(-)
>>
>> --
>> 2.15.1
> 
> 

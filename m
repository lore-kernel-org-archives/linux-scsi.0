From: "Brown, Len" <len.brown@intel.com>
Subject: RE: 2.6.13-mm1: hangs during boot ...
Date: Sat, 3 Sep 2005 11:57:07 -0400
Message-ID: <F7DC2337C7631D4386A2DF6E8FB22B30047FA090@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr16.intel.com ([192.55.52.70]:31981 "EHLO
	fmsfmr006.fm.intel.com") by vger.kernel.org with ESMTP
	id S1751071AbVICP5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Sep 2005 11:57:21 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

>> > Please then try the latest ACPI patch here:
>>  > 
>http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches
>/release/2.6.13/acpi-20050902-2.6.13.diff.gz
>>  > It should apply to vanilla 2.6.13 with a reject in ia64/Kconfig
>>  > that you can ignore.
>>  > 
>>  > If this works, then we munged git-acpi.patch in 
>2.6.13-mm1 somehow.
>> 
>>  There were no problems with this patch applied.  So it 
>looks like the 
>>  munge theory is correct.
>
>That diff is significantly different from the diff I plucked from
>master.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
>.git#test
>for 2.6.13-mm1.
>
>Doing (patch -R | grep FAILED) on 2.6.13-mm1 says:

Right.
2.6.13/acpi-20050902-2.6.13.diff.gz
is newers than 2.6.13-rc1's git-acpi.patch

2.6.13/acpi-20050815-2.6.13.diff.gz
is a closer match -- though not exact.

Peter, it might be illustrative if you have a moment
if you can also test 2.6.13/acpi-20050815-2.6.13.diff.gz
all by itself.

If it fails, then I broke -mm1
with acpi-20050815-2.6.13.diff.gz, but fixed
it by acpi-20050902-2.6.13.diff.gz.

If it succeeds, then the issue lies in the relatively small delta
between acpi-20050815-2.6.13.diff.gz 2.6.13-mm1's git-acpi.patch.

thanks,
-Len


From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
Date: Sat, 22 Mar 2008 23:59:33 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803222357370.6948@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de> <200803220226.35552.rjw@sisk.pl> <20080321222606.16407d74.akpm@linux-foundation.org> <alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de> <alpine.DEB.1.00.0803222128570.6948@sheep.housecafe.de>
 <20080322150848.bf165996.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758514AbYCVW7o@vger.kernel.org>
In-Reply-To: <20080322150848.bf165996.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 22 Mar 2008, Andrew Morton wrote:
>> Hm, this was strange: I applied Neil's patch (and the dm-crypt patch) on
>> 2.6.25-rc6 and I kept getting SCSI errors (and lockups) when doing "tar
>> -cf - | dd of=/dev/null" - which I did to generate disk I/O.
>
> Please send all the details about this, retaining all cc's.

Hm, reproducing seems easy, but as nothings get written to disk or to the 
remote syslog server anymore, I don't have any error messages - yet.

C.
-- 
BOFH excuse #93:

Feature not yet implemented

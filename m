From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Date: Thu, 5 Jul 2012 15:12:21 +0000
Message-ID: <4FF5AECA.40801@intel.com>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
 <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Content-Language: en-US
Content-ID: <DBF9902A13537C42BD177ECCD98407C3@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Scan Subscription <scan-subscription@coverity.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>, Bing Zhao <bzhao@marvell.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 7/3/2012 3:27 PM, Andrew Morton wrote:
> On Thu, 28 Jun 2012 11:32:09 -0700
> Scan Subscription <scan-subscription@coverity.com> wrote:
>
> ____________________________________________________________________________________________________________
> CID 703581 -  NO_EFFECT Unsigned compared against 0 - This less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
>
> drivers/scsi/fcoe/fcoe_sysfs.c:105
> 100 static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
> 101 {
> 102        int ret;
> 103
> 104        ret = kstrtoul(buf, 0, val);
>>>>> CID 703581: Unsigned compared against 0 (NO_EFFECT) This less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
>> 105        if (ret || *val < 0)
>> 106                return -EINVAL;
>> 107        /*
>> 108         * Check for overflow; dev_loss_tmo is u32
>>
Patch posted to linux-scsi.

Thanks, //Rob
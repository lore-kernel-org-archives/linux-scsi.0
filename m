From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] block: Export REQ_FLUSH status via sysfs
Date: Wed, 14 May 2014 17:29:16 -0700
Message-ID: <53740A5C.1040103@redhat.com>
References: <1400107908-16095-1-git-send-email-agrover@redhat.com> <1400112663.7127.64.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1400112663.7127.64.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/14/2014 05:11 PM, Nicholas A. Bellinger wrote:
> On Wed, 2014-05-14 at 15:51 -0700, Andy Grover wrote:
>> Whether this is set or not is important for whether good performance is
>> possible, when using the block device as a backstore for the kernel
>> target. Exposing this will let kernel target configuration tools provide
>> this information to the user when configuring LIO targets.
>>
>
> The whole point is that IBLOCK detects if WCE is enabled on the
> underlying block_device at creation time using these same flags, and
> sets its own WCE bit automatically without any user interaction.
>
> The user should not be allowed to change the WCE bit to something
> different from what the underlying block_device is reporting.
>
> That said, I don't see the point of this patch for target related logic.

My understanding is that a LIO target backed by a block device that 
doesn't support REQ_FLUSH will have subpar performance.

Userspace configuration tools could potentially warn the user if this is 
the case.

This information doesn't appear to be currently available to userspace.

Regards -- Andy

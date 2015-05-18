From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Mon, 18 May 2015 15:01:56 +0200
Message-ID: <5559E2C4.1020900@redhat.com>
References: <1431940681-15915-1-git-send-email-dvlasenk@redhat.com> <5559E1FB.2070004@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5559E1FB.2070004@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Christoph Hellwig <hch@lst.de>, Ben Hutchings <ben@decadent.org.uk>, James Bottomley <JBottomley@Parallels.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/18/2015 02:58 PM, Guenter Roeck wrote:
> On 05/18/2015 02:18 AM, Denys Vlasenko wrote:
>> __bfa_trc() compiles to 115 bytes of machine code.
>> With this .config: http://busybox.net/~vda/kernel_config
>> there are 1494 calls of __bfa_trc().
>>
>> __bfa_trc32() is very similar, so it is uninlined too.
>> However, it appears to be unused, therefore this patch
>> ifdefs it out.
>>
> Why not just remove it ?

I'm not familiar with the code, figured maintainers know better.

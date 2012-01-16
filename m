From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/3] possible privilege escalation via SG_IO ioctl
 (CVE-2011-4127)
Date: Mon, 16 Jan 2012 09:54:07 +0100
Message-ID: <4F13E5AF.3080805@redhat.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com> <4F13779E.1070807@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F13779E.1070807@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 01/16/2012 02:04 AM, Douglas Gilbert wrote:
>>
>>
>> Tested on top of 3.2 + Linus's patch to sanitize ioctl return values.
>
> Is that a fixed version of patch at the end of this post:
> http://marc.info/?l=linux-kernel&m=132578310403616&w=2
> The fix being
>    s/ENOIOCTLCMD/-ENOIOCTLCMD/
> in is_unrecognized_ioctl() ?

Yes.  I cherry-picked it from Linus's tree.

> Also could you post "PATCH v2 3/3 ..." to this list as well so
> we have a complete set?

FWIW, 3/3 only touches LVM.

Paolo

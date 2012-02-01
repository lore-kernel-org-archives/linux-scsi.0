From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
Date: Wed, 01 Feb 2012 09:21:23 +0100
Message-ID: <4F28F603.50104@redhat.com>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com> <4F26596B.6030703@redhat.com> <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com> <4F28F42A.1050103@redhat.com> <alpine.LFD.2.02.1202011017200.7303@tux.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1202011017200.7303@tux.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Pekka Enberg <penberg@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Sasha Levin <levinsasha928@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2012 09:18 AM, Pekka Enberg wrote:
>>>
>>
>> Of course.  I would have proposed it for staging otherwise.
>
> I'm not a SCSI expert but FWIW I went through the patches and I think
> they're definitely worthwhile having in mainline for v3.4:
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Thanks Pekka!

Actually we had a conflict on the virtio id, so I'll have to respin with 
the id changed to 8.

Paolo

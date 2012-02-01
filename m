From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
Date: Wed, 1 Feb 2012 10:18:48 +0200 (EET)
Message-ID: <alpine.LFD.2.02.1202011017200.7303@tux.localdomain>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com> <4F26596B.6030703@redhat.com> <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com> <4F28F42A.1050103@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F28F42A.1050103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Sasha Levin <levinsasha928@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 1 Feb 2012, Paolo Bonzini wrote:
>> Have the virtio specification changes been reviewed? Can we guarantee
>> stable ABI for the virtio-scsi driver?
>
> Of course.  I would have proposed it for staging otherwise.

I'm not a SCSI expert but FWIW I went through the patches and I think 
they're definitely worthwhile having in mainline for v3.4:

Acked-by: Pekka Enberg <penberg@kernel.org>

 			Pekka

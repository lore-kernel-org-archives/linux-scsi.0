From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v3 5/6] virtio-scsi: fix various bad behavior on aborted requests
Date: Wed, 4 Jun 2014 20:10:45 -0700
Message-ID: <CAHdzE--6krnQ2H9yyfNzX5Y4RoZs-XfKdmFzPufxpMp5hx33pQ@mail.gmail.com>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
	<1401881699-1456-6-git-send-email-pbonzini@redhat.com>
	<CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
	<538F6DEB.2000601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <538F6DEB.2000601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@parallels.com, stable@vger.kernel.org, Venkatesh Srinivas <vsrinivas@ops101.org>
List-Id: linux-scsi@vger.kernel.org

On 6/4/14, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 04/06/2014 19:29, Venkatesh Srinivas ha scritto:
>> Do you really want to poll the request VQs for completions if the TMF
>> was rejected?
>
> I wasn't sure, but bugs in this path are hard enough that I preferred
> the safer patch.

Ok. As long as it was deliberate. I'd slightly prefer only doing so in
the success case, but simplicity is a compelling argument :)

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;

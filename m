From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: Re: [PATCH 1/4] pnp: pnpbios: Add explicit X86_32 dependency to
 PNPBIOS
Date: Sun, 1 May 2016 11:52:39 -0400
Message-ID: <20160501155239.GA19900@sophia>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
 <bbb2f28f39cbda8923eedca61bb5d9c55520f674.1460379702.git.vilhelm.gray@gmail.com>
 <571AB8F6.50802@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <571AB8F6.50802@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Apr 23, 2016 at 01:51:19AM +0200, Rafael J. Wysocki wrote:
>On 4/11/2016 3:25 PM, William Breathitt Gray wrote:
>> The PNPBIOS driver requires preprocessor defines (located in
>> include/asm/segment.h) only declared if the architecture is set to
>> X86_32. If the architecture is set to X86_64, the PNPBIOS driver will
>> not build properly. The X86 dependecy for the PNPBIOS configuration
>> option is changed to an explicit X86_32	dependency in order to prevent
>> an attempt to build for an unsupported architecture.
>>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
>
>Has anyone taken care of this already?
>
>If not, can you possibly resend this patch with a CC to 
>linux-acpi@vger.kernel.org so I can pick it up via Patchwork more easily?

I'm not sure when this patchset will appear in driver-core, so I have
resent this particular patch with a CC to linux-acpi@vger.kernel.org so
that Rafael J. Wysocki can pick it up more easily.

William Breathitt Gray

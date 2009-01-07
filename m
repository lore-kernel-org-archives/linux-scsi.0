From: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: [PATCH 0/6] v2: Asynchronous function calls to speed up booting and more
Date: Wed, 7 Jan 2009 12:44:03 -0500
Message-ID: <48f7fe350901070944y558366f0j9a23b12a993c4355@mail.gmail.com>
References: <20090105201508.23e98b4b@infradead.org>
	 <48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
	 <20090107070810.675799a5@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090107070810.675799a5@infradead.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

yes it boots with out the acpi patch

On 1/7/09, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 6 Jan 2009 22:19:33 -0500
> "Ryan Hope" <rmh3093@gmail.com> wrote:
>
>> i can't boot with these patches... the kernel panic was something
>> along the line of:
>>
>> ata_piix: device unavailable because of BAR 0 collisions
>
> ok as a hunch.. could you try this but without the ACPI part of the
> patch?
>
>
> --
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

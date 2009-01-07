From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/6] v2: Asynchronous function calls to speed up booting
 and more
Date: Wed, 7 Jan 2009 07:08:10 -0800
Message-ID: <20090107070810.675799a5@infradead.org>
References: <20090105201508.23e98b4b@infradead.org>
	<48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 6 Jan 2009 22:19:33 -0500
"Ryan Hope" <rmh3093@gmail.com> wrote:

> i can't boot with these patches... the kernel panic was something
> along the line of:
> 
> ata_piix: device unavailable because of BAR 0 collisions

ok as a hunch.. could you try this but without the ACPI part of the
patch?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

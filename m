From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Mon, 5 Jan 2009 20:25:14 -0800
Message-ID: <20090105202514.399da36e.akpm@linux-foundation.org>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201041.3289d3dd@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105201041.3289d3dd@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 5 Jan 2009 20:10:41 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

>  kernel/async.c         |  307 ++++++++++++++++++++++++++++++++++++++++++++++++

Am still wondering if this is unacceptably duplicative of dhowells's
slow-work infrastructure: http://lkml.org/lkml/2008/11/20/193



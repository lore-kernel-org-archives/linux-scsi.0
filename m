From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: fix PCI IDs for new Smart Array controllers
Date: Mon, 18 Oct 2010 12:55:45 -0700
Message-ID: <20101018125545.908d97d4.akpm@linux-foundation.org>
References: <20101018185307.GA11223@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101018185307.GA11223@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2010 13:53:07 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 1 of 1
> cciss: fix PCI IDs for new controllers
> 
> This patch fixes the botched up PCI IDs of new controllers. Please consider
> this patch for inclusion.
> 

What was botched up about it?

What are the runtime effects of this change?

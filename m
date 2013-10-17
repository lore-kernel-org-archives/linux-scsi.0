From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
Date: Thu, 17 Oct 2013 14:13:37 -0700
Message-ID: <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
References: <20131017175226.GA31535@thumper.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131017175226.GA31535@thumper.usa.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com> wrote:

> cpqarray hasn't been used in over 12 years. It's doubtful that anyone still
> uses the board. It's time the driver was removed from the mainline kernel.
> The only updates these days are minor and mostly done by people outside of HP.

It's amazing the weird stuff people get up to.  Perhaps we should disable
it in config for a cycle or two, see if that flushes anyone out?

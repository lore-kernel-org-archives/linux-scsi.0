From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 10:05:15 -0400
Message-ID: <18075.31515.974905.507754@stoffel.org>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765917AbXGPOGd@vger.kernel.org>
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jens> A repost of this patchset, which adds support forchaining of sg
Jens> tables.  This enables much larger IO commands, since we don't
Jens> have to allocate large consecutive pieces of memory to represent
Jens> the sgtable of a huge command. Right now Linux is limited to
Jens> somewhere between 128 and 256 segments, depending on the
Jens> architecture. This translates into at most 512k-1mb request
Jens> sizes. With this patchset, I've successfully pushed 10MiB
Jens> commands through the IO stack.

Will this help out tape drive performance at all?  I looked through
the patches quickly, esp the AIC7xxx stuff since that's what I use,
but nothing jumped out at me...

John

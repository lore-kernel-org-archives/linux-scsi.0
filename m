From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c into using pci_get device
Date: Sat, 16 Feb 2008 09:37:57 -0700
Message-ID: <20080216163756.GG7657@parisc-linux.org>
References: <47B1ADCE.40202@larces.uece.br> <1202833354.3137.19.camel@localhost.localdomain> <47B1CF45.5070407@panasas.com> <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain> <47B2B101.3090106@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757576AbYBPQiO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47B2B101.3090106@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sergio Luis <sergio@larces.uece.br>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 13, 2008 at 10:57:37AM +0200, Boaz Harrosh wrote:
> I still don't have a card for testing myself. Again anyone
> wants to send me a card. Intel people anybody home?

Apparently Intel sold this line of cards to Adaptec.  The copyright
notice in the file backs this up:

 * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner                 *
 * Copyright (C) 2002-04 Intel Corporation                              *
 * Copyright (C) 2003-06 Adaptec Inc.                                   *
 * <achim_leubner@adaptec.com>                                          *

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

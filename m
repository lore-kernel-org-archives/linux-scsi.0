From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
 backward compatibility
Date: Fri, 11 Apr 2003 01:57:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304110154590.12110-100000@serv>
References: <UTC200304102209.h3AM9pf11795.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200304102209.h3AM9pf11795.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

Hi,

On Fri, 11 Apr 2003 Andries.Brouwer@cwi.nl wrote:

> The conclusion is that the easy way out is to define MAX_NR_DISKS.
> A different way out, especially when we use 32+32, is to kill this
> sd_index_bits[] array, and give each disk a new number: replace
> 	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
> by
> 	index = next_index++;

This one is fun:
http://www.ussg.iu.edu/hypermail/linux/kernel/0103.3/0394.html

Anyway, unless you fix all programs which scan /dev/sg*, you better keep 
the used range dense, so this not really option.

bye, Roman

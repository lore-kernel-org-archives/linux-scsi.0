From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 4 Apr 2018 13:32:52 -0700
Message-ID: <CAGXu5jLTSd4wx6hxj6FCJ4O2PkqFyRw6nwu=0Y1NpoaRZKefWw@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10360653.ov98egbaqx@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 4, 2018 at 12:07 PM, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
> [  261.262135] Bad or missing usercopy whitelist? Kernel memory exposure
> attempt detected from SLUB object 'scsi_sense_cache' (offset 94, size 22)!
> I can easily reproduce it with a qemu VM and 2 virtual SCSI disks by calling
> smartctl in a loop and doing some usual background I/O. The warning is
> triggered within 3 minutes or so (not instantly).

Also:

Can you send me your .config? What SCSI drivers are you using in the
VM and on the real server?

Are you able to see what ioctl()s smartctl is issuing? I'll try to
reproduce this on my end...

-Kees

-- 
Kees Cook
Pixel Security

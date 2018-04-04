From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 4 Apr 2018 16:47:12 -0400
Message-ID: <b7fe22f9-4820-11fe-fe92-cf246642d9f6@interlog.com>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLTSd4wx6hxj6FCJ4O2PkqFyRw6nwu=0Y1NpoaRZKefWw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLTSd4wx6hxj6FCJ4O2PkqFyRw6nwu=0Y1NpoaRZKefWw@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-04-04 04:32 PM, Kees Cook wrote:
> On Wed, Apr 4, 2018 at 12:07 PM, Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
>> [  261.262135] Bad or missing usercopy whitelist? Kernel memory exposure
>> attempt detected from SLUB object 'scsi_sense_cache' (offset 94, size 22)!
>> I can easily reproduce it with a qemu VM and 2 virtual SCSI disks by calling
>> smartctl in a loop and doing some usual background I/O. The warning is
>> triggered within 3 minutes or so (not instantly).
> 
> Also:
> 
> Can you send me your .config? What SCSI drivers are you using in the
> VM and on the real server?
> 
> Are you able to see what ioctl()s smartctl is issuing? I'll try to
> reproduce this on my end...

smartctl -r scsiioctl,3 ....

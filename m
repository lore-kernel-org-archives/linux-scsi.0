From: Michael Reed <mdr@sgi.com>
Subject: Re: Infinite retries reading the partition table
Date: Tue, 05 Dec 2006 14:40:49 -0600
Message-ID: <4575D951.3010705@sgi.com>
References: <520003.85125.qm@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S968691AbWLEUkz@vger.kernel.org>
In-Reply-To: <520003.85125.qm@web31807.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



Luben Tuikov wrote:
...snip...
> This statement in scsi_io_completion() causes the infinite retry loop:
>    if (scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
>          return;

The code in 2.6.19 is "result==0", not "!!result", which is logically
the same as "result!=0".  Did you mean to change the logic here?
Am I missing something?

Mike

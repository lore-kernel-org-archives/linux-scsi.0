From: Matthew Jacob <mjacob@feral.com>
Subject: Re: RAID status with fusion mpt driver
Date: Thu, 13 Feb 2003 09:02:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030213090110.F86888-100000@beppo>
References: <200302131037.17635.mb@blumenstrasse.vol.at>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200302131037.17635.mb@blumenstrasse.vol.at>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Brunner <mb@blumenstrasse.vol.at>
Cc: linux-scsi@vger.kernel.org


You should contact Pam Delaney about this, but I believe that some
different async events are anounced when internal state changes. Not
sure that mpt in Linux groks them though.

BTW- I'd be *really* interested in hearing what your performance dropoff
for two disks in RAID-1 vs. 'real' mode is in this box.

On Thu, 13 Feb 2003, Matthias Brunner wrote:

> Hello,
>
> I have an IBM xSeries with an LSI53C1030 integrated RAID controller,
> a RAID-1 is set up.
> The array appears as a virtual SCSI disk (/dev/sda).
> So how can I learn the state of the RAID and - even more important -
> be notified if one of the disks fails? What will the logs say (so I
> can use logsurfer)?
> Files in /proc/mpt and below are not very helpful in that respect.
>
> Kernel version: 2.4.20
> --
> Matthias Brunner <mb@blumenstrasse.vol.at>
> PGP FP 7862 32B3 3B75 292A F76F  5042 8587 21AB 5B89 D501
> Check out http://blumenstrasse.vol.at/~mb/gpgkey.asc
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


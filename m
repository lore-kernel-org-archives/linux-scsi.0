From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: [RFC] Discard update for 3.19
Date: Fri, 7 Nov 2014 12:11:07 +0000
Message-ID: <F6E129D0B46B7F4B89EF4089CE55578C045C9146@LAX-EX-MB4.datadirect.datadirectnet.com>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

> The second patch tweaks the SCSI disk driver to prefer WRITE SAME w/
> UNMAP instead of the UNMAP command since the former has deterministic
> behavior.

I have seen data corruption on an Intel SSD 510 after sending WRITE SAME
UNMAP. As far as I remember, these disks ignore writes after sending
that command. Unmap worked fine, though. So possibly there is another
blacklisting required.

Cheers,
Bernd


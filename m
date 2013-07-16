From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2] [SCSI] scsi_debug: silence GCC warning
Date: Tue, 16 Jul 2013 17:29:46 +0200
Message-ID: <1373988586.17662.4.camel@x61.thuisdomein>
References: <1373879920.2591.13.camel@x61.thuisdomein>
	 <1373914081.2591.40.camel@x61.thuisdomein>
	 <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-07-17 at 00:21 +0900, Akinobu Mita wrote:
> This one looks good to me.

Thanks.

> It would be much better if this commit
> log had a reference to the commit that introduced this warning as
> you described after '---' in v1 patch.

Do you mean that I should submit a v3, with a commit explanation that
also has one or two lines that mention commit beb40ea42b ("[SCSI]
scsi_debug: reduce duplication between prot_verify_read and
prot_verify_write")?


Paul Bolle

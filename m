From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Fwd: 32bit dev_t
Date: 28 Jan 2003 18:22:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043778170.24849.5.camel@irongate.swansea.linux.org.uk>
References: <OF6219FB58.D7DE4198-ON87256CBC.0059CD9E-88256CBC.005B0ABA@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF6219FB58.D7DE4198-ON87256CBC.0059CD9E-88256CBC.005B0ABA@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, 2003-01-28 at 16:33, Bryan Henderson wrote:
> 
> 
> This has probably been discussed to death somewhere, but I missed it:  Why
> are people with hundreds of disks messing around with piles of major
> numbers and eliminating disk partitioning instead of just using devfs?
> Doesn't that make dev_t pretty much irrelevant?

Short answer: No

Long answer: SuS stat() and related calls require the device is identified, as does
NFS. Devfs also hasn't got good permission persistence and has other big problems
in 2.4 at least


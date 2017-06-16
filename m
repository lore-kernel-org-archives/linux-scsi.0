From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [RFC] ubsan: signed integer overflow in scsi_partsize
Date: Fri, 16 Jun 2017 08:01:27 -0700
Message-ID: <8a48d772-9860-b74f-25fc-57bda30bd663@wdc.com>
References: <20170616132932.GG20222@alitoo>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170616132932.GG20222@alitoo>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alice Ferrazzi <alicef@gentoo.org>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/16/17 06:29, Alice Ferrazzi wrote:
> A Gentoo user reported a USBAN signed integer overflow in scsicam.c
> Shall we change something?

Hello Alice,

Some of the code in drivers/scsi/scsicam.c duplicates code in
block/partitions/msdos.c and block/genhd.c. I think patches that remove
the partition table parsing code from drivers/scsi/scsicam.c and that
use the generic partition table parsing code instead would be more than
welcome.

Bart.

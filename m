From: Dave <dave.jiang@gmail.com>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 08:52:48 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8746466a0408260852205a7842@mail.gmail.com>
References: <412DFFA9.8030504@wasp.net.au>
Reply-To: Dave <dave.jiang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412DFFA9.8030504@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 26 Aug 2004 19:20:09 +0400, Brad Campbell <brad@wasp.net.au> wrote:
> G'day all,
> 
> Hot on the trail of this libata oddity.
> 
> 
> ATA_MAX_SECTORS == 200.
> 
> Should then the scsi layer be able to do this and queue 1/2 a Meg in a single request?
> 
> Am I looking at something completely weird? Is the block layer doing something I should know about?
> Can SATA transfers handle 1024 sectors in one go? Will Batman make it out of the cave alive?

That is decimal 200, not hex 200. Technically with ATA (or SATA)
drives you can bump it to 0x100 (256). That is the limitation of LBA28
drives. With LBA48 drives you can do 0xffff (64k) sectors per request
I believe. I wish the SATA layer would allow a mechanism to auto
detect drive being LBA48 or LBA28 and adjust accordingly instead of
just default to a very low sector count.

-- 
-= Dave =-

Software Engineer - Advanced Development Engineering Team 
Storage Component Division - Intel Corp. 
mailto://dave-DOT-jiang-AT-intel-DOT-com 
----
The views expressed in this email are
mine alone and do not necessarily 
reflect the views of my employer
(Intel Corp.).

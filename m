From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 12:30:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412E1039.7030508@pobox.com>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8746466a0408260852205a7842@mail.gmail.com>
To: Dave <dave.jiang@gmail.com>
Cc: Brad Campbell <brad@wasp.net.au>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Dave wrote:
> I believe. I wish the SATA layer would allow a mechanism to auto
> detect drive being LBA48 or LBA28 and adjust accordingly instead of
> just default to a very low sector count.


The SATA layer already does this...  but only on 2.6.x kernels.

drivers/scsi/libata-scsi.c, ata_scsi_slave_config()

	Jeff



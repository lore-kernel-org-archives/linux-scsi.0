From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: Tree for May 6 (lpfc)
Date: Mon, 06 May 2013 13:36:16 -0400
Message-ID: <yq1ehdkggdr.fsf@sermon.lab.mkp.net>
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
	<5187D6F1.9070103@infradead.org> <1367858965.1868.24.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1367858965.1868.24.camel@dabdike> (James Bottomley's message of
	"Mon, 06 May 2013 09:49:25 -0700")
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, James Smart <james.smart@emulex.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> drivers/built-in.o: In function `lpfc_bg_crc': (.text+0x3cb3c9):
>> undefined reference to `crc_t10dif'

James> That's the usual minor config cockup, isn't it?  lpfc apparently
James> also needs the generic checksum, so the fix would seem to be
James> this.

Patch ok as a short term fix.

Longer term I'd like to provide a helper function that HBAs can call to
validate the data and PI scatterlists.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] libata: add TRIM support
Date: Mon, 16 Nov 2009 19:19:39 +0300
Message-ID: <4B017B9B.6090702@ru.mvista.com>
References: <20091116154343.GA6672@infradead.org> <20091116160748.3c58218e@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091116160748.3c58218e@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

Hello.

Alan Cox wrote:

>> +	min_io_sectors = 1;
>> +	if ((args->id[106] & 0xc000) == 0x4000 && (args->id[106] & (1 << 13)))
>> +		min_io_sectors *= args->id[106] & 0xf;
>>     
>
> That magic probably wants to be an ata_id_foo helper of some sort but
> otherwise all looks sensible enough for ATA. I'm assuming gcc is smart
> enough to collapse that into
>
> 	id[106] & 0xE000 != 0x6000
>   

   You probably meant ==, not !=. Not sure if gcc is that smart...

WBR, Sergei


